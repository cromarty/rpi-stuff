#!/bin/bash

set -e

RCPID=$(pgrep raspi-config)
[ "${RCPID}" ] && { echo "-- Killing the raspi-config process" ; kill -9 "${RCPID}" ; }
[ -f/etc/profile.d/raspi-config.sh ] && { echo "-- Deleting the file /etc/profile.d/raspi-config.sh" ; rm /usr/profile.d/raspi-config.sh ; }
[ -d "${BUILD_PATH}" ] || { echo "-- Makeing the build path" ; mkdir -p "${BUILD_PATH}" ; }
cd "${BUILD_PATH}"
echo "-- Add sources repo to /etc/apt/sources.list..."
echo "deb-src http://archive.raspbian.org/raspbian wheezy main contrib non-free rpi" >> /etc/apt/sources.list
wget http://archive.raspbian.org/raspbian.public.key -O - | apt-key add -
apt-get update
echo "-- Install equivs and devscripts so we can build packages..."
apt-get -y -q install equivs devscripts
exit 0

