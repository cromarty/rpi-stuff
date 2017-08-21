#!/bin/bash
#

# Set up the defaults
archroot=root
packagelist=package_list.txt

usage="this is the usage"

set -e

while getopts ":d:l:" opt
do
	case $opt in
d)
archroot="$OPTARG"
;;
		l)
			packagelist=$OPTARG
		;;
		\?)
			echo $usage
			exit 1
			;;
esac
done

if [ ! -r ${packagelist} ]; then
	echo "Package list: ${packagelist} does not exist or is not readable" 
	exit 1
fi



if mount | grep "${archroot}" > /dev/null; then
	# it's a mount point (device mounted)
#pacstrap "${archroot}" $(cat $packagelist) 
else
	# no it's not a mounted mount point
	[ -d "${archroot}" ] || mkdir "${archroot}"
	pacstrap -d "${archroot}" $(cat $packagelist)
fi

sync


# After the above:
#
# 1. arch-chroot
# 2. passwd root
# 3. set the hostname
# 4. Add another user
# 5. Enable sshd
# 6. Enable dhcpcd
