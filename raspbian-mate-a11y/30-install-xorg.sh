#!/bin/bash

if [ `whoami` != 'root' ]; then
    echo "Script must be run as root, try: sudo $0"
    exit 2
fi

set +e

# Are we running on Arch?
uname -a | grep -i arch
if [ ! $? ]; then
	echo "This script currently doesn't work for Arch. Script will exit"
	exit 0
fi

set -e


echo 'Installing xorg stuff...'
apt-get install -yq xserver-xorg-core xserver-xorg-video-fbdev
#xserver-xorg-video-dummy

echo 'All done'

exit 0
