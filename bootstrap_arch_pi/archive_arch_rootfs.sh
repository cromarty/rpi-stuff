#!/bin/bash

export TEXTDOMAIN=archive_arch_rootfs
export TEXTDOMAINDIR=.

. gettext.sh

usage() {
	echo "You buggered it up again"
}

#defaults
log=archive_arch_rootfs.log
archive=arch_rootfs.tar.gz
source=./root

# create a temporary list of socket files to exclude
find ${source} -type s -print > /tmp/sockets-to-exclude

while getopts ":a:l:s:" opt
do
	case $opt in
		a)
			archive=${OPTARG}
		;;
		l)
			log=${OPTARG}
		;;
		s)
			source=${OPTARG}
		;;
		\?)
			usage
			exit 1
		;;
	esac
done

tar cvpzf \
	"${archive}" \
	-X /tmp/sockets-to-exclude \
	--exclude=${source}/proc \
	--exclude=${source}/lost+found  \
	--exclude=${source}/tmp \
	--exclude=/${source}/mnt \
	--exclude=${source}/sys ${source} \
	> "${log}"
