#!/bin/bash

ILCTTS_VERSION=1.0.0

if [ `whoami` != 'root' ]; then
	echo "Script must be run as root, try: sudo $0"
	exit 1
fi

set -e

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

echo 'All done!'


exit 0

 
