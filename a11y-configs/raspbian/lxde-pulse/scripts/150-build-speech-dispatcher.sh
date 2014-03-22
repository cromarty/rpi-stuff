#!/bin/bash

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result
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
  --without-libao \
  --with-alsa \
  --with-pulse

check_errs $? "Failed in configure"

make all
check_errs $? "Failed in make all"

make install
check_errs $? "Failed in make install"

echo "$0 Completed successfully" | tee -a script.result
exit 0
