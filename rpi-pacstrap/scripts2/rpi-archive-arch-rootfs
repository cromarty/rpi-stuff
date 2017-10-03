#!/bin/bash

export TEXTDOMAIN=rpi-pacstrap-rootfs
export TEXTDOMAINDIR=.

. gettext.sh

. ./rpi-pacstrap-arch-rootfs.lib

usage() {
	echo $(gettext "usage")
}

archroot=root
archive=backup.tar.gz
logfile=backup.log

while getopts ':a:hl:r:' opt
do
	case $opt in
		h)
			usage
			exit 0
		;;
		a)
			archive="${OPTARG}"
		;;
		l)
			logfile="${OPTARG}"
		;;
		r)
			archroot="${OPTARG}"
		;;
			\?)
			usage
			exit 1
		;;
	esac
done

if [ ! -d "${archroot}" ]; then
	echo "Root file system path does not exist"
	exit 1
fi

if [ -e "${archive}" ]; then
	echo "Backup archive file exists, not overwriting, exiting"
	exit 1
fi



archive_arch_rootfs "${archroot}" "${archive}" "${logfile}"


