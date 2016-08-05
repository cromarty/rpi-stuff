#!/bin/bash
#
# 1. Install Mate
# 2. Install lightdm
# 3. Install orca
# 4. Configure lightdm
# 5. Set gsettings switches for root
#

if [ `whoami` != 'root' ]; then
    echo 'Script must be run as root'
    exit 1
fi

set -e

echo 'Installing a bunch of stuff, this will take a long time...'
apt-get install -yq mate-core mate-desktop-environment lightdm gnome-orca


sed -i 's|# AudioOutputMethod "pulse"| AudioOutputMethod "alsa"|' /etc/speech-dispatcher/speechd.conf
sed -i 's|; autospawn yes|autospawn no|' /etc/pulse/client.conf

rm /usr/share/alsa/pulse*
rm /usr/share/alsa/alsa.conf.d/*pulse*
	
chmod -x /usr/bin/start-pulse*

sed -i 's|#greeter-wrapper=$|greeter-wrapper=/usr/bin/orca-dm-wrapper|' /etc/lightdm/lightdm.conf

dbus-launch gsettings set org.mate.interface accessibility true
dbus-launch gsettings set org.gnome.desktop.a11y.applications screen-reader-enabled true

exit 0

