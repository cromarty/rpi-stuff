#!/bin/bash

BUILD_PATH=$(ls -d espeak-*/src)

if [ $(id -u) -ne 0 ]; then
	echo "-- Script must be run as root. Try 'sudo $0'"
	exit 1
fi

cd "${BUILD_PATH}"

cp portaudio19.h portaudio.h

export LDFLAGS=-L/usr/lib/arm-linux-gnueabihf

make all || exit 1
make install
exit $?


