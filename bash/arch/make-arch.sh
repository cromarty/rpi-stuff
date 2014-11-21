#!/bin/bash
# make a custom arch image
# You will need kpartx, losetup and bsdtar
#
# Note that vanilla tar won't work, the .tar.gz was created with bsdtar.
#
# Usual GPL stuff about no guarantees etc.
#

# working directory
WRK=arch-latest

# image file name
IMG=ArchLinuxARM-$(date +%F | sed 's:-::g').img

# tweak block count if necessary. Could be smaller perhaps to fit a 2GB card?
blocks=1998
split=64

# mount points of file-systems created in the .IMG file
bootmp=boot
rootmp=root

# chosen hostname
HOSTNAME=caroline

if [ $(id -u) -ne 0 ]; then
    echo "Script must be run as root, try 'sudo ./$0'"
     exit 1
fi

set -e
echo "Making the work directory if it doesn't exist..."
if [ ! -d ${WRK} ]; then
	mkdir -p "${WRK}"
fi

echo "cd to work directory..."
cd ${WRK}/

echo "Running dd to make a raw image file, this will take a few minutes..."
echo "Name of image file will be ${IMG}"
dd if=/dev/zero of=${IMG} bs=1M count=${blocks}
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
bootp=${device}p1

# root partition
rootp=${device}p2

echo "Boot partition is ${bootp}"
echo "Root partition is ${rootp}"

echo -e "${bootp}\n${rootp}\n\n" > loop-dev-names

echo "Making file systems..."
mkfs.vfat $bootp
mkfs.ext4 $rootp

# make the mount points
echo "Making the mount points if they don't exist..."
if [ ! -d ${bootmp} ]; then
	mkdir -p ${bootmp}
fi

if [ ! -d ${rootmp} ]; then
	mkdir -p ${rootmp}
fi

# mount the two partitions
echo "Mounting the two partitions..."
mount $bootp ${bootmp}
mount $rootp ${rootmp}

echo 'Downloading the latest Arch...'
wget -q http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz 
echo 'Extracting the filesystems...'
bsdtar -xpf ArchLinuxARM-rpi-latest.tar.gz -C ${rootmp}

# move the boot stuff into the boot partition
mv root/boot/* boot

# write the chosen hostname into /etc/hostname
echo "${HOSTNAME}" > root/etc/hostname

sync

# un-mount the partitions contained in the .IMG file
umount ${bootmp}
umount ${rootmp}

dmsetup remove ${bootp}
dmsetup remove ${rootp}


# now take the .IMG file and write it
# to an SD card in the normal way




