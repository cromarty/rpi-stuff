#!/bin/bash

PIESPEAKUP_VERSION=1.0.0

if [ `whoami` != 'root' ]; then
	echo "Script must be run as root, try: sudo $0"
	exit 1
fi

set -e

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

echo 'All done!'


exit 0

 
