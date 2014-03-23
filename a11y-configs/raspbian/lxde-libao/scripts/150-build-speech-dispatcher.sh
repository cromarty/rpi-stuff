#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Building speech-dispatcher..."
LOCAL_BUILD_PATH=$(ls -d speech-dispatcher-*)
cd "${LOCAL_BUILD_PATH}"
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
exit 0
