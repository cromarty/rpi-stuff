#!/bin/bash
#
# make-rpi-arch
#
# Copyright (C) 2016 Mike Ray <mike.ray@btinternet.com>
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
# This code is supplied as is and without any guarantees of fitness for purpose and without liability either stated
# or implied.
#
# You will need losetup and kpartx.
#


usage() {

	cat <<eof

Usage:

-h | --help Usage

     Display this usage message and exit.

-w | --workdir Work directory

     Name of the working directory.
     
     Default = './work'

-c | --bcount Block count

     Number of blocks to allocate for a new image file.

     Default = 2000

-z | --bsize Block size

          Block-size for the dd command.

     Default = '1M'.

-s | --split Split

     Split between boot and root partition, will be size of boot partition in number of blocks.

     Default = 64.

-a | --arch

     Architecture

-n | --hostname

     Hostname to be used.

     Default = 'alarmpi'

eof

  
	exit 1
} # end usage

checkargs() {
	if [ $# -lt 2 ]; then
		usage
	fi
} # end check_args


validate_blockcount() {
	local BLOCKCOUNT=${1}

echo "$BLOCKCOUNT" | grep "^[0-9][0-9]*$" >/dev/null
if [ $? -eq 1 ]; then
		echo 'Bad block count'
		usage
fi
} # end validate_blockcount


validate_split() {
    local SPLIT=$1

echo "${SPLIT}" | grep "^[0-9][0-9]*$" >/dev/null
if [ $? -eq 1 ]; then
		echo 'Bad split value'
		usage
fi
} # end validate_split


validate_blocksize() {
	local BLOCKSIZE=${1}

	case ${BLOCKSIZE} in
			'1M'|'1MB')
			#
		;;
		*)
			usage
		;;
esac

} # end validate_blocksize
validate_arch() {
    local ARCH=${1}

    case ${ARCH} in
	'armv6'|'armv7'|'armv8')
	    #break
	    ;;
	*)
	    usage
	    ;;
    esac

} # end validate_arch

check_root() {
	if [ `whoami` != 'root' ]; then
		echo "Script must be run as root, try 'sudo $0'"
		exit 1
	fi

} # end check_root

dry_run() {
    local WORKDIR=$(realpath ${1})
    local BOOTMP=${WORKDIR}/${2}
    local ROOTMP=${WORKDIR}/${3}
    local BLOCKSIZE=${4}
    local BLOCKCOUNT=${5}
    local SPLIT=${6}
	local HNAME=${7}
	local ARCH=${8}

	echo -e "Dry-run:\n\n"
	echo "Working directory (WORKDIR) = ${WORKDIR}"
	echo "Boot mount-point (BOOTMP) = ${BOOTMP}"
	echo "Root mount-point (ROOTMP) = ${ROOTMP}"
	echo "Block size (BLOCKSIZE) = ${BLOCKSIZE}"
	echo "Block count (BLOCKCOUNT) = ${BLOCKCOUNT}"
	echo "Split (SPLIT) = ${SPLIT}"
	echo "Hostname (HNAME) = ${HNAME}"
	echo "Architecture (ARCH) = ${ARCH}"
	exit 0
} # end dry_run
    
make_image() {
    local WORKDIR=$(realpath ${1})
    local BOOTMP=${WORKDIR}/${2}
    local ROOTMP=${WORKDIR}/${3}
    local BLOCKSIZE=${4}
    local BLOCKCOUNT=${5}
    local SPLIT=${6}
	local HNAME=${7}
	local ARCH=${8}

    local IMAGEFILE=${WORKDIR}/ArchLinuxARM-$(date +%F | sed 's:-::g').${ARCH}.img

	echo "Making the work directory if it doesn't exist..."
	[ -d ${WORKDIR} ] || mkdir -p "${WORKDIR}"

	echo 'Running dd to make a raw (zero-filled) image file'
	echo "Name of image file will be ${IMAGEFILE}"
	dd if=/dev/zero of=${IMAGEFILE} bs=1M count=${BLOCKCOUNT}

	echo "Partitioning the raw image file..."
	echo 'Making an msdos label...'
	parted ${IMAGEFILE} --script -- mklabel msdos
	echo 'Making the boot partition...'
	parted ${IMAGEFILE} --script -- mkpart primary fat32 1 ${SPLIT}
	echo 'Setting the boot partition bootable...'
	parted ${IMAGEFILE} --script set 1 boot on
	echo 'Making the root partition...'
	parted ${IMAGEFILE} --script -- mkpart primary ext4 ${SPLIT} -1

	echo "Setting up the loop device..."
	LOOPDEVICE=$(losetup -f --show ${IMAGEFILE})
	echo "Loop device is ${LOOPDEVICE}"
	DEVICE=$(kpartx -va ${LOOPDEVICE} | sed -E 's|.*(loop[0-9][0-9]*)p.*|\1|g' | head -1)
	DEVICE="/dev/mapper/${DEVICE}"
	# boot partition
	BOOTP=${DEVICE}p1

	# root partition
	ROOTP=${DEVICE}p2

	echo "Boot partition is ${BOOTP}"
	echo "Root partition is ${ROOTP}"

	sleep 5

	#echo -e "${BOOTP}\n${ROOTP}\n\n" > ${WORKDIR}/loop-dev-names

	echo "Making file systems..."
	mkfs.vfat ${BOOTP}
	mkfs.ext4 ${ROOTP}

	# make the mount points
	echo "Making the mount points if they don't exist..."
	[ -d ${BOOTMP} ] || 	mkdir -p ${BOOTMP}
	[ -d ${ROOTMP} ] || mkdir -p ${ROOTMP}

	# mount the two partitions
	echo "Mounting the two partitions..."
	mount ${BOOTP} ${BOOTMP}
	mount ${ROOTP} ${ROOTMP}

	echo 'Downloading the latest Arch...'
	case ${ARCH} in
		'armv6')
			wget -q http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz -O "${WORKDIR}/arch-latest-${ARCH}.tar.gz" 
		;;
		'armv7')
			wget -q http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz -O "${WORKDIR}/arch-latest-${ARCH}.tar.gz"
		;;
		'armv8')
			wget -q http://archlinuxarm.org/os/ArchLinuxARM-rpi-3-latest.tar.gz -O "${WORKDIR}/arch-latest-${ARCH}.tar.gz"
		;;
			*)
			echo 'Incorrect value for ARCH'
			exit 1
	esac

	echo 'Extracting the filesystems...'
	gunzip ${WORKDIR}/arch-latest-${ARCH}.tar.gz
	set +e
	tar -xpf ${WORKDIR}/arch-latest-${ARCH}.tar -C ${ROOTMP}
	set -e
	# move the boot stuff into the boot partition
	echo 'Move the boot files into the boot partition...'
	mv ${ROOTMP}/boot/* ${BOOTMP}

	# write the chosen hostname into /etc/hostname
	echo 'Writing the host name...'
	echo "${HNAME}" > ${ROOTMP}/etc/hostname

	sync

	# un-mount the partitions contained in the .IMG file
	echo 'Un-mount the partitions...'
	umount "${BOOTMP}"
	umount "${ROOTMP}"

	echo 'Remove the loop devices...'
	dmsetup remove "${BOOTP}"
	dmsetup remove "${ROOTP}"

	echo "Remove the mount-points..."
	rmdir ${BOOTMP}
	rmdir ${ROOTMP}
	# Note: On my Debian x86_64 machine the loop devices persist until I reboot.  No
	# idea why

} # end make_image

#-- main code

while :
do
	case "$1" in
		-h|--help)
			usage
		;;
		-w|--work)
			WORKDIR=$2
			shift 2
		;;
				-a|--arch)
			ARCH=$2
			shift 2
		;;
		-c|--blockcount)
			BLOCKCOUNT=$2
			shift 2
		;;
		-z|--blocksize)
			BLOCKSIZE=$2
			shift 2
		;;
		-s|--split)
			SPLIT=$2
			shift 2
		;;
		-n|--hostname)
			HNAME=$2
			shift 2
		;;
		-d|--dryrun)
			DRYRUN=1
			shift
		;;
		-*)
			echo "Unrecognised arg"
			exit 1
		;;
		--)
			shift
			break
		;;
		*)
			break
		;;
esac
done

set -e

check_root

WORKDIR=${WORKDIR:=./work}
BOOTMP=boot
ROOTMP=root
BLOCKSIZE=${BLOCKSIZE:=1M}
BLOCKCOUNT=${BLOCKCOUNT:=2000}
SPLIT=${SPLIT:=64}
HNAME=${HNAME:=alarmpi}

validate_blockcount ${BLOCKCOUNT}
validate_split ${SPLIT}
validate_blocksize ${BLOCKSIZE}
validate_arch ${ARCH}


if [ ${DRYRUN} ]; then
	dry_run ${WORKDIR} ${BOOTMP} ${ROOTMP} ${BLOCKSIZE} ${BLOCKCOUNT} ${SPLIT} ${HNAME} ${ARCH}
else
	make_image ${WORKDIR} ${BOOTMP} ${ROOTMP} ${BLOCKSIZE} ${BLOCKCOUNT} ${SPLIT} ${HNAME} ${ARCH}
fi

exit 0
