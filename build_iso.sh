#!/bin/bash

cd mame-live
sudo lb clean
sudo lb build

# If a device was provided, make it a Live MAME device.
if [ "$#" -gt 0 ]; then
	device=$1

	if [[ -f "live-image-i386.hybrid.iso" ]]; then
	    echo "Dumping iso to ${device}"
		sudo dd if="live-image-i386.hybrid.iso" of="${device}" bs=32M

	    echo "Partitioning left space as persistence device."
		echo -e "n\np\n2\n\n\nw\n" | sudo fdisk "${device}"
		sudo mkfs.ext4 -L persistence "${device}2"
		
		mkdir /tmp/mame-mnt
		sudo mount "${device}2" /tmp/mame-mnt

		echo "Copying persistence.conf to persistence device."
		sudo cp ../persistence.conf /tmp/mame-mnt
		
		echo "Crating rom and artwork dir"
		sudo mkdir /tmp/mame-mnt/roms 
		sudo mkdir /tmp/mame-mnt/artwork

		sudo umount "${device}2"
		sync

		rm -r /tmp/mame-mnt
	fi
fi