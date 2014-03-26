#!/bin/bash

set -e
cd "${BUILD_PATH}"
## get the source
echo '-- Getting the speech-dispatcher source...'
apt-get -y -q source speech-dispatcher
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
