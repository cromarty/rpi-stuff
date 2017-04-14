#!/bin/bash

if [ `whoami` != 'root' ]; then
	echo "Script must be run as root. Try sudo $0"
	exit 1
fi

set -e

ILCTTS_VERSION=1.0.0
PIESPEAKUP_VERSION=1.1.0

VIDEODEVICE=xserver-xorg-video-fbdev
#VIDEODEVICE=xserver-xorg-video-dummy

GREETER=

echo 'Performing an update...'
apt-get -yq update

echo 'Installing espeak and espeak development files...'
apt-get install -yq libespeak-dev espeak

echo 'Getting ilctts library code from www.raspberryvi.org...'
wget http://www.raspberryvi.org/Downloads/ilctts-${ILCTTS_VERSION}.tar.gz
echo 'Extracting the library code...'
tar -zxf ilctts-${ILCTTS_VERSION}.tar.gz
cd ilctts-${ILCTTS_VERSION}
echo 'Configuring library code for a build...'
./configure
./fix-timestamps.sh
echo 'Making the library...'
make -s
echo 'Installing the library...'
make install
cd ..

echo 'Executing ldconfig...'
ldconfig

echo 'Tidying up...'
rm -rf ilctts-${ILCTTS_VERSION}/
rm ilctts-${ILCTTS_VERSION}.tar.gz

echo 'Writing to /etc/modules...'
echo -e "\n\nspeakup_soft\n\n" >> /etc/modules
echo 'Loading speakup_soft for this session...'
modprobe speakup_soft

echo 'Getting the piespeakup code from www.raspberryvi.org...'
wget http://www.raspberryvi.org/Downloads/piespeakup-${PIESPEAKUP_VERSION}.tar.gz
echo 'Extracting the piespeakup code...'
tar zxf piespeakup-${PIESPEAKUP_VERSION}.tar.gz
cd piespeakup-${PIESPEAKUP_VERSION}
echo 'Configuring piespeakup for a build...'
./configure
./fix-timestamps.sh
echo 'Making piespeakup...'
make -s
echo 'Installing piespeakup...'
make install
cd ..

echo 'Enabling and starting the piespeakup service...'
systemctl enable piespeakup.service
systemctl start piespeakup.service

echo 'Tidying up...'
rm -rf piespeakup-${PIESPEAKUP_VERSION}/
rm piespeakup-${PIESPEAKUP_VERSION}.tar.gz

echo 'Installing xorg stuff...'
apt-get install -yq xserver-xorg-core ${VIDEODEVICE}

echo 'Editing /lib/modprobe.d/aliases.conf...'
sed -i 's|^\(options snd-usb-audio index=\)|#\1|' /lib/modprobe.d/aliases.conf

echo 'Editing /boot/config.txt...'
sed -i 's|^\(dtparam=audio=on\)|#\1|' /boot/config.txt

echo 'Installing some stuff, this will take a long time...'
apt-get install -yq mate-core mate-desktop-environment gnome-orca xinit

if [ ${GREETER} ]; then
    echo 'Installing the lightdm greeter..'
    apt -get install -yq lightdm
    echo 'Editing /etc/lightdm/lightdm.conf...'
    sed -i 's|^#\(greeter-wrapper=\)|\1/usr/bin/orca-dm-wrapper|' /etc/lightdm/lightdm.conf
    echo 'Adding the lightdm user to the audio group...'
    usermod -a -G audio lightdm
fi

echo 'Removing unused speech-dispatcher modules...'
rm /usr/lib/speech-dispatcher-modules/sd_cicero
rm /usr/lib/speech-dispatcher-modules/sd_flite
rm /usr/lib/speech-dispatcher-modules/sd_generic

echo "All done"
exit 0
