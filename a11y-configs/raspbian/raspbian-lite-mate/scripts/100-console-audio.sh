#!/bin/bash
#
# 1. Update the OS
# 2. Configure for USB audio
# 3. Install espeak and espeakup
# 4. Enable speakup_soft
#

if [ `whoami` != 'root' ]; then
	echo 'Script must be run as root'
	exit 1
fi

set -e

apt-get -y update

sed -i 's|\(options snd-usb-audio index=-2\)|#\1|' /lib/modprobe.d/aliases.conf
	sed -i 's|\(dtparam=audio=on\)|#\1|' /boot/config.txt

echo -e "\n\nspeakup_soft\n\n" >> /etc/modules

modprobe speakup_soft

echo 'Installing espeak and espeakup...'
apt-get install -yq espeak espeakup

exit 0

