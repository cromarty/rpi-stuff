#!/bin/bash

set -e

if [ $(pgrep raspi-config) ]; then
	echo "-- Killing the nasty raspi-config process"
	kill -9 $(pgrep raspi-config)
fi

if [ -f /etc/profile.d/raspi-config.sh ]; then
	echo "-- Deleting the file /etc/profile.d/raspi-config.sh"
	rm /etc/profile.d/raspi-config.sh
fi

if [ ! -d "${BUILD_PATH}" ]; then
	echo "-- Makeing the build path"
	mkdir -p "${BUILD_PATH}"
fi

cd "${BUILD_PATH}"
echo "-- Add sources repo to /etc/apt/sources.list..."
echo "deb-src http://archive.raspbian.org/raspbian wheezy main contrib non-free rpi" >> /etc/apt/sources.list
wget http://archive.raspbian.org/raspbian.public.key -O - | apt-key add -
apt-get update
echo "-- Install equivs and devscripts so we can build packages..."
apt-get -y -q install equivs devscripts
exit 0

