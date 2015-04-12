#!/bin/bash
# make a custom arch image
# You will need parted, kpartx, losetup and bsdtar
#
# Note that vanilla tar won't work, the .tar.gz was created with bsdtar.
#
# Usual GPL stuff about no guarantees etc.
#
# Mike Ray, January 2015
#

# ARM version
# armv6 for original Raspberry Pi
# armv7 for Raspberry Pi 2
# Comment out as needed

ARMV=armv6
#ARMV=armv7

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

if [ $(id -u) -ne 0 ]; then
    echo "Script must be run as root, try 'sudo ./$0'"
     exit 1
fi

set -e

case ${ARMV} in
	armv6)
		echo 'Creating an ARMV6 image file'
	;;
	armv7)
		echo 'Creating an ARMV7 image file'
	;;
	*)
		echo 'Incorrect ARMV setting'
		exit 1
	;;
esac

echo "Making the work directory if it doesn't exist..."
if [ ! -d ${WRK} ]; then
	mkdir -p "${WRK}"
fi

echo "cd to work directory..."
cd ${WRK}/

echo "Running dd to make a raw image file, this will take a few minutes..."
echo "Name of image file will be ${IMG}"
dd if=/dev/zero of=${IMG} bs=1M count=${BLOCKS}
echo "Partitioning the raw image file..."
parted ${IMG} --script -- mklabel msdos
parted ${IMG} --script -- mkpart primary fat32 1 ${split}
parted ${IMG} --script set 1 boot on
parted ${IMG} --script -- mkpart primary ext4 ${split} -1

echo "Setting up the loop device..."
loopdevice=`losetup -f --show ${IMG}`
echo "Loop device is ${loopdevice}"
device=`kpartx -va ${loopdevice} | sed -E 's/.*(loop[0-9])p.*/\1/g' | head -1`
device="/dev/mapper/${device}"

# boot partition
BOOTP=${device}p1

# root partition
ROOTP=${device}p2

echo "Boot partition is ${BOOTP}"
echo "Root partition is ${ROOTP}"

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
		wget http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz -O arch-latest.tar.gz
	;;
		*)
		echo 'Incorrect value for ARMV'
		exit 1
esac

echo 'Extracting the filesystems...'
bsdtar -xpf arch-latest.tar.gz -C ${ROOTMP}

# move the boot stuff into the boot partition
mv root/boot/* boot

# write the chosen hostname into /etc/hostname
echo "${HOSTNAME}" > root/etc/hostname

sync

# un-mount the partitions contained in the .IMG file
umount ${BOOTMP}
umount ${ROOTMP}

dmsetup remove ${BOOTP}
dmsetup remove ${ROOTP}
#
# Note: On my Debian x86_64 machine the loop devices persist until I reboot.  No
# idea why
#


# now take the .IMG file and write it
# to an SD card in the normal way

exit 0

