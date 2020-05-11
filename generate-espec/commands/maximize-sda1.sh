#!/bin/bash

echo "** Disabling swap"
swapoff -a

echo "** Updating partition table"

# This magic string means:
# create one partition from start to end of disk (the +), without specified id, and make it bootable (the *)
echo ",+,,*" | sfdisk /dev/sda --no-reread

#force online reload of partition table
echo "** Forcing re-read of partition table"
partprobe

echo "** Resizing file-system"
resize2fs /dev/sda1

echo "** Reinstating swap via swapfile of 2G"
SWAPSIZE=$(expr 2 \* 1024 \* 1024)

sudo dd if=/dev/zero of=/swapfile bs=1024 count=$SWAPSIZE
chmod 600 /swapfile
mkswap /swapfile 
swapon /swapfile

echo "** Update /etc/fstab"
mv /etc/fstab /etc/fstab.bak

echo "*** OLD fstab:"
cat /etc/fstab.bak

cat /etc/fstab.bak | grep -v swap >> /etc/fstab
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

echo "*** NEW /etc/fstab:"
cat /etc/fstab
