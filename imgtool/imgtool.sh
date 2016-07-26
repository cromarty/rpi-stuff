#!/bin/bash
#
# imgtool.sh
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

-f | --func { mount|new|cleanup} Function

     mount = Mount a previously created image file.
          new = Create and mount a new image (.img) file.
          cleanup = Un-mount img partitions, remove the loop devices and remove the mount-points

-i | --image Image file name file

     Name of the image file to create/mount. Mandatory.
     
-w | --workdir Work directory

     Name of the working directory. Mandatory.
     
-b | --bootmp Boot mount point

     Name of the mount-point where the boot partition of the image file will be mounted.

     Default = 'bootmp'
     
-r | --rootmp Root mount point

     Name of the mount-point where the root partition of the image file will be mounted.
     
          Default = 'rootmp'

-c | --bcount Block count

     Number of blocks to allocate for a new image file. Mandatory.

-z | --bsize Block size

          Block-size for the dd command.

     Default = '1M'.

-s | --split Split

     Split between boot and root partition, will be size of boot partition in number of blocks.

     Default = 64.

eof

  
	exit 1
}

checkargs() {
	if [ $# -lt 2 ]; then
		usage
	fi
}


new_image() {

	set -e

	echo "Making the work directory if it doesn't exist..."
	if [ ! -d ${WRK} ]; then
		mkdir -p "${WRK}"
	fi

	echo "cd to work directory..."
	cd ${WRK}

	echo 'Running dd to make a raw image file, this will take about 30 seconds, depending on the speed of your machine...'
	dd if=/dev/zero of=${IMG} bs=${BLOCKSIZE} count=${BLOCKCOUNT}

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

}

mount_image() {
	set -e

	echo "Making the work directory if it doesn't exist..."
	if [ ! -d ${WRK} ]; then
		mkdir -p "${WRK}"
	fi

	echo "cd to work directory..."
	cd ${WRK}

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

	echo "Making the mount points if they don't exist..."
	if [ ! -d ${BOOTMP} ]; then
		mkdir -p ${BOOTMP}
	fi

	if [ ! -d ${ROOTMP} ]; then
		mkdir -p ${ROOTMP}
	fi

	echo $(realpath ${BOOTMP}) > mount-points
	echo $(realpath ${ROOTMP}) >> mount-points

	echo "Mounting the two partitions..."
	mount ${BOOTP} ${BOOTMP}
	mount ${ROOTP} ${ROOTMP}

	echo 'Finished'

}

validate_blocksize() {

case "$BLOCKSIZE" in
	'1M')
	;;
	'1MB')
		;;
	*)
		echo 'Invalid block-size'
		usage
		exit 1
	;;
esac

    
}

validate_blockcount() {
echo "$BLOCKCOUNT" | grep "^[0-9][0-9]*$" >/dev/null
if [ $? -eq 1 ]; then
		echo 'Bad block count'
		usage
fi
}


remove_loop_devices() {
	set +e
	echo 'Removing loop devices...'
	[ -f loop-dev-names ] || { echo 'loop-dev-names does not exist' ; exit 1 ; }
	cat loop-dev-names | \
	while read LOOP
	do
		echo "Removing loop device ${LOOP}..."
		dmsetup remove ${LOOP}
	done

}


remove_mount_points() {
	set +e
	echo 'Removing mount points...'
	[ -f mount-points ] || { echo 'mount-points does not exist' ; exit 1 ; }
	cat mount-points | \
	while read MOUNTPOINT
	do
		rmdir ${MOUNTPOINT}
	done
}

un_mount_partitions() {
	set +e
	echo 'Un-mounting partitions...'
	cat mount-points | \
	while read MOUNTPOINT
	do
		umount ${MOUNTPOINT}
	done
}

clean_up() {
	cd "${WRK}"
	un_mount_partitions
	remove_mount_points
	remove_loop_devices
	rm mount-points
	rm loop-dev-names
}




check_root() {
	if [ `whoami` != 'root' ]; then
		echo 'Script must be run as root'
		exit 1
	fi
}

#-- main code

BLOCKSIZE=1M
BOOTMP=bootmp
ROOTMP=rootmp
SPLIT=64

while :
do
	case "$1" in
		-b | --bootmp)
			checkargs $*
			BOOTMP="$2"
			shift 2
		;;
		-r | --rootmp)
			checkargs $*
			ROOTMP="$2"
			shift 2
		;;
		-c | --bcount)
			checkargs $*
			BLOCKCOUNT="$2"
			shift 2
		;;
		-z | --bsize)
			checkargs $*
			BLOCKSIZE="$2"
			shift 2
		;;
		-h | --help)
			usage
			# no shifting needed here, we're done.
			exit 0
		;;
		-i | --image)
			checkargs $*
			IMG="$2"
			shift 2
		;;
		-s | --split)
			checkargs $*
			SPLIT="$2"
			shift 2
		;;
		-w | --workdir)
			checkargs $*
			WRK="$2"
			shift 2
		;;
		-f | --func)
			FUNC=$2
			shift 2
		;;
		--)
			shift
			break;
		;;
		-*)
			echo "Error: Unknown option: $1" >&2
			usage
			exit 1
		;;
		*)
			break
		;;
	esac

done

check_root


[ -z "$WRK" ] && { echo 'No working directory supplied' ; usage ; }
[ -z "$FUNC" ] && { echo 'No function supplied' ; usage ; }



case "$FUNC" in
	'mount')
		[ -z "$IMG" ] && { echo 'Image file name is missing' ; usage ; }
		[ -f "${WRK}/${IMG}" ] || { echo 'Image file does not exist' ; exit 1 ; }  
		mount_image
	;;
	'new')
		[ -z "$IMG" ] && { echo 'Image file name is missing' ; usage ; }
		[ -z "$BLOCKCOUNT" ] && { echo 'No block-count supplied' ; usage ; }
		[ -z "$BLOCKSIZE" ] && { echo 'No block-size supplied' ; usage ; }
		[ -z "$SPLIT" ] && { echo 'No split-size supplied' ; usage ; }
		validate_blockcount
		validate_blocksize
		new_image
	;;
	'cleanup')
		clean_up
	;;
	*)
		echo 'Invalid function'
		usage
		exit 1
	;;
esac

exit 0
