#!/bin/bash

set -e

[ `pgrep raspi-config` ] && kill `pgrep raspi-config`
[ -f /etc/profile.d/raspi-config.sh] && rm /usr/profile.d/raspi-config.sh
mkdir -p "${BUILD_PATH}"
cd "${BUILD_PATH}"
echo "-- Add sources repo to /etc/apt/sources.list..."
echo "deb-src http://archive.raspbian.org/raspbian wheezy main contrib non-free rpi" >> /etc/apt/sources.list
wget http://archive.raspbian.org/raspbian.public.key -O - | apt-key add -
apt-get update
echo "-- Install equivs and devscripts so we can build packages..."
apt-get -y -q install equivs devscripts
echo "-- Running autoremove..."
apt-get -y autoremove
exit 0

