#!/bin/bash
#
# make-rpi-arch.sh
# Copyright (C) 2015 Mike Ray <mike.ray@btinternet.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# Make a custom Raspberry Pi Arch Linux image
#
# You will need parted, kpartx, losetup and bsdtar
#
# Note that vanilla tar won't work, the .tar.gz downloaded from the ArchARM site was created with bsdtar.
#
# Note added 21/09/2017. The tarball will fail to extract properly unless you have
# bsdtar 3.3+.  A good excuse for using an Arch desktop and not Debian or Ubuntu.
#
# Look for HOSTNAME further down the script to change your
# chosen host name.
#
# The default user and password combinations are:
#
# User:          alarm
# Password:      alarm
# root password: root
#
#


usage() {
	echo
	echo "Usage: $0 {armv6|armv7|armv8}"	echo
	echo 'armv6 for original Pi, armv7 for Pi2, armv8 for 64-bit Pi3'
	echo
}

if [ `whoami` != 'root' ]; then
	echo 'Script must be run as root'
	exit 1
fi

if [ $# != 1 ]; then
	usage
	exit 1
fi

ARMV=${1}

case ${ARMV} in
	armv6)
		echo 'Creating an ARMV6 image file'
	;;
	armv7)
		echo 'Creating an ARMV7 image file'
	;;
	armv8)
		echo 'Creating an ARMV8 image file'
	;;
	*)
		usage
		exit 1
	;;
esac


# working directory
WRK=arch-latest-${ARMV}

# Image file name. Will
# include the date
IMG=ArchLinuxARM-$(date +%F | sed 's:-::g').${ARMV}.img

# Tweak block count if necessary. Could be smaller perhaps to fit a 2GB card?
BLOCKS=1998

# size of FAT partition to receive kernel etc, in blocks
SPLIT=64

# mount points of file-systems created in the .IMG file
# sub-directories of working dir will be created with these names
BOOTMP=boot
ROOTMP=root

# chosen hostname
HOSTNAME=alarmpi

set -e


echo "Making the work directory if it doesn't exist..."
if [ ! -d ${WRK} ]; then
	mkdir -p "${WRK}"
fi

echo "cd to work directory..."
cd ${WRK}/

echo 'Running dd to make a raw image file, this will take about 30 seconds, depending on the speed of your machine...'
echo "Name of image file will be ${IMG}"
dd if=/dev/zero of=${IMG} bs=1M count=${BLOCKS}
echo "Partitioning the raw image file..."
echo 'Making an msdos label...'
parted ${IMG} --script -- mklabel msdos
echo 'Making the boot partition...'
parted ${IMG} --script -- mkpart primary fat32 1 ${SPLIT}
echo 'Setting the boot partition bootable...'
parted ${IMG} --script set 1 boot on
echo 'Making the root partition...'
parted ${IMG} --script -- mkpart primary ext4 ${SPLIT} -1

echo "Setting up the loop device..."
LOOPDEVICE=`losetup -f --show ${IMG}`
echo "Loop device is ${LOOPDEVICE}"
DEVICE=`kpartx -va ${LOOPDEVICE} | sed -E 's/.*(loop[0-9])p.*/\1/g' | head -1`
DEVICE="/dev/mapper/${DEVICE}"

# boot partition
BOOTP=${DEVICE}p1

# root partition
ROOTP=${DEVICE}p2

echo "Boot partition is ${BOOTP}"
echo "Root partition is ${ROOTP}"

sleep 5

echo -e "${BOOTP}\n${ROOTP}\n\n" > loop-dev-names

echo "Making file systems..."
mkfs.vfat ${BOOTP}
mkfs.ext4 ${ROOTP}

# make the mount points
echo "Making the mount points if they don't exist..."
if [ ! -d ${BOOTMP} ]; then
	mkdir -p ${BOOTMP}
fi

if [ ! -d ${ROOTMP} ]; then
	mkdir -p ${ROOTMP}
fi

# mount the two partitions
echo "Mounting the two partitions..."
mount ${BOOTP} ${BOOTMP}
mount ${ROOTP} ${ROOTMP}

echo 'Downloading the latest Arch...'
case ${ARMV} in
	armv6)
		wget -q http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz -O arch-latest.tar.gz 
	;;
	armv7)
		wget -q http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz -O arch-latest.tar.gz
	;;
	armv8)
		wget -q http://archlinuxarm.org/os/ArchLinuxARM-rpi-3-latest.tar.gz -O arch-latest.tar.gz
	;;
		*)
		echo 'Incorrect value for ARMV'
		exit 1
esac

echo 'Extracting the filesystems...'
bsdtar -zxvf arch-latest.tar.gz -C ${ROOTMP}
#tar -xpf arch-latest.tar.gz -C ${ROOTMP}


# move the boot stuff into the boot partition
echo 'Move the boot files into the boot partition...'
mv root/boot/* boot

# write the chosen hostname into /etc/hostname
echo 'Writing the host name...'
echo "${HOSTNAME}" > root/etc/hostname


sync

# un-mount the partitions contained in the .IMG file
echo 'Un-mount the partitions...'
umount ${BOOTMP}
umount ${ROOTMP}

echo 'Remove the loop devices...'
dmsetup remove ${BOOTP}
dmsetup remove ${ROOTP}
#
# Note: On my Debian x86_64 machine the loop devices persist until I reboot.  No
# idea why
#


# now take the .IMG file and write it
# to an SD card in the normal way

exit 0

