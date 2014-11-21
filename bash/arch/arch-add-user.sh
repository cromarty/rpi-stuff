#!/bin/bash

if [ -z $1 ]; then
	echo "No user name given. Usage: arch-add-user"
	exit 1
fi

if [ $(id -u) -ne 0 ]; then
	echo "Must be run as root.  Script will exit"
	exit 1
fi


useradd -m -g users -G audio,lp,storage,video,wheel,games,power -s /bin/bash $1 || return 1

echo "Setting password for user $1"
passwd $1 || echo "Failed to set password for user $1"

echo "Done"
exit 0
