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

echo 'Editing /lib/modprobe.d/aliases.conf...'
sed -i 's|^\(options snd-usb-audio index=\)|#\1|' /lib/modprobe.d/aliases.conf

echo 'Editing /boot/config.txt...'
sed -i 's|^\(dtparam=audio=on\)|#\1|' /boot/config.txt

echo 'Installing some stuff, this will take a long time...'
apt-get install -yq xserver-xorg-core xserver-xorg-video-fbdev
#xserver-xorg-video-dummy
apt-get install -yq mate-core mate-desktop-environment gnome-orca xinit

echo 'All done'

exit 0
