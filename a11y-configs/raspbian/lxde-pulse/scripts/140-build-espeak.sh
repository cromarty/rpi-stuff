#!/bin/bash

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result
echo "-- Building espeak..."

LOCAL_BUILD_PATH=$(ls -d espeak-*/src)

cd "${LOCAL_BUILD_PATH}"

cp portaudio19.h portaudio.h

make all
check_errs $? "Failed in espeak make all"
make install
check_errs $? "Failed in espeak make install"
install -m 755 speak /usr/bin
check_errs $? "Failed to install the speak binary"

echo "$0 Completed successfully" | tee -a script.result
exit 0



