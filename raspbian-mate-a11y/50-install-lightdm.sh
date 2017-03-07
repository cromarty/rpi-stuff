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

echo 'Installing the lightdm greeter..'
apt -get install -yq lightdm
	
echo 'Editing /etc/lightdm/lightdm.conf...'
sed -i 's|^#\(greeter-wrapper=\)|\1/usr/bin/orca-dm-wrapper|' /etc/lightdm/lightdm.conf

echo 'Adding the lightdm user to the audio group...'
usermod -a -G audio lightdm


echo 'All done'

exit 0
