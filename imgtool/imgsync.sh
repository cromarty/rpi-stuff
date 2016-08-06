#!/bin/bash


usage() {
	cat <<eof

Usage: $0 --source-bootmp DIRECTORY --source-rootmp DIRECTORY --target-bootmp DIRECTORY --target-rootmp DIRECTORY

	Arguments:

		--source-bootmp
			The source boot mount-point.

		--source-rootmp
			The source root mount-point.

		--target-bootmp
			The target boot mount-point.

		--target-rootmp
			The target root mount-point.

	All arguments are mandatory.

eof

	exit 1

}


checkargs() {
	if [ $# -lt 2 ]; then
		usage
	fi
}

validate_source_bootmp() {
	[ -d $1 ] || { echo "The specified source boot mount-point does not exist" ; exit 1 ; }
	[ -f "$1/cmdline.txt" ] || { echo "I don't think the source boot mount-point is the boot partition of a mounted Raspberry Pi image, there is no cmdline.txt file" ; exit 1 ; }
}

validate_source_rootmp() {
	[ -d "$1" ] || { echo "The specified source root mount-point does not exist" ; exit 1 ; }
	[ -d "$1/lost+found" ] || { echo "I don't think the specified source root mount-point is a mounted Linux partition, there is no lost+found directory" ; exit 1 ; }
	[ -d "$1/usr/bin" ] || { echo "I don't think the specified source root mount-point contains Linux, there is no /usr/bin directory" ; exit ; }
}

validate_target_bootmp() {
	[ -d $1 ] || { echo "The specified target boot mount-point does not exist" ; exit 1 ; }
}

validate_target_rootmp() {
	[ -d $1 ] || { echo "The specified target root mount-point directory does not exist" ; exit 1 ; }
}


#-- Main program

if [ `whoami` != 'root' ]; then
	echo 'Script must be run as root'
	exit 1
fi

set -e

SOURCE_BOOTMP=
SOURCE_ROOTMP=
TARGET_BOOTMP=
TARGET_ROOTMP=

[ $# -eq 8 ] || { echo "There must be exactly eight arguments" ; usage ; }


while :
do
	case "$1" in
	"--source-bootmp")
		checkargs $*
		validate_source_bootmp $2
		SOURCE_BOOTMP="$2"
		shift 2
	;;
	"--source-rootmp")
		checkargs $*
		validate_source_rootmp $2
		SOURCE_ROOTMP="$2"
		shift 2
	;;
	"--target-bootmp")
		checkargs $*
	validate_target_bootmp $2
		TARGET_BOOTMP="$2"
		shift 2
	;;
	"--target-rootmp")
		checkargs $*
		validate_target_rootmp $2
		TARGET_ROOTMP="$2"
		shift 2
	;;
		"--")
		shift
		break
	;;
		-*)	
				usage
	;;
	*)
	break
;;
esac
done

echo "Source boot mount-point: ${SOURCE_BOOTMP}"
echo "Source root mount-point: ${SOURCE_ROOTMP}"
echo "Target boot mount-point: ${TARGET_BOOTMP}"
echo "Target root mount-point: ${TARGET_ROOTMP}"

rsync -rav ${SOURCE_BOOTMP}/* ${TARGET_BOOTMP}
#rsync -rav --exclude=lost+found ${SOURCE_ROOTMP}/* ${TARGET_ROOTMP}

