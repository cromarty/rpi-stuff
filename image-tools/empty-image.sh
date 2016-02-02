#!/bin/bash

if [ `whoami` != 'root' ]; then
	echo 'Script must be run as root'
	exit 1
fi

WRK=work
IMG=empty-image.img

BLOCKSIZE=1M
BLOCKS=1935
SPLIT=64

BOOTMP=blow/boot
ROOTMP=blow/root

set -e

echo "Making the work directory if it doesn't exist..."
if [ ! -d ${WRK} ]; then
	mkdir -p "${WRK}"
fi

echo "cd to work directory..."
cd ${WRK}



echo 'Running dd to make a raw image file, this will take about 30 seconds, depending on the speed of your machine...'
dd if=/dev/zero of=${IMG} bs=${BLOCKSIZE} count=${BLOCKS}

echo "Partitioning the raw image file..."
parted ${IMG} --script -- mklabel msdos
echo 'Making the boot partition...'
parted ${IMG} --script -- mkpart primary fat32 1 ${SPLIT}
echo 'Setting the boot partition bootable...'
parted ${IMG} --script set 1 boot on
echo 'Making the root partition...'
parted ${IMG} --script -- mkpart primary ext4 ${SPLIT} -1

echo "Setting up the loop device..."
LOOPDEVICE=`losetup -f --show ${IMG}`
DEVICE=`kpartx -va ${LOOPDEVICE} | sed -E 's/.*(loop[0-9][0-9]*)p.*/\1/g' | head -1`
DEVICE="/dev/mapper/${DEVICE}"

BOOTP=${DEVICE}p1
ROOTP=${DEVICE}p2

echo "Boot partition is ${BOOTP}"
echo "Root partition is ${ROOTP}"

echo -e "${BOOTP}\n${ROOTP}" > loop-dev-names

sleep 5

echo "Making file systems..."
mkfs.vfat ${BOOTP}
mkfs.ext4 ${ROOTP}


echo "Making the mount points if they don't exist..."
if [ ! -d ${BOOTMP} ]; then
	mkdir -p ${BOOTMP}
fi

if [ ! -d ${ROOTMP} ]; then
	mkdir -p ${ROOTMP}
fi

echo -e "${BOOTMP}\n${ROOTMP}" > mount-points

echo "Mounting the two partitions..."
mount ${BOOTP} ${BOOTMP}
mount ${ROOTP} ${ROOTMP}

echo 'Finished'
exit 0
