#!/bin/bash


set -e
cd "${BUILD_PATH}"
echo "-- Building espeak..."
LOCAL_BUILD_PATH=$(ls -d espeak-*/src)
cd "${LOCAL_BUILD_PATH}"
cp portaudio19.h portaudio.h
make all
make install
install -m 755 speak /usr/bin
exit 0



