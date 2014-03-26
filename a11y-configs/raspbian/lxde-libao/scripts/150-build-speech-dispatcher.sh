#!/bin/bash

set -e
cd "${BUILD_PATH}"
## get the source
echo '-- Getting the speech-dispatcher source...'
#apt-get -y -q source speech-dispatcher
wget http://devel.freebsoft.org/pub/projects/speechd/speech-dispatcher-0.7.1.tar.gz
tar -xzf speech-dispatcher-0.8.tar.gz
echo "-- Building speech-dispatcher..."
pushd $(ls -d speech-dispatcher-*)
./configure \
  --prefix=/usr \
   --sysconfdir=/etc \
  --libdir=/usr/lib/arm-linux-gnueabihf \
  --enable-shared \
  --disable-static \
  --without-flite \
  --without-ibmtts \
  --with-espeak \
  --without-ivona \
  --without-nas \
  --without-oss \
  --with-libao \
  --with-alsa \
  --with-pulse

make all
make install
popd
echo '-- Finished building speech-dispatcher'
exit 0
