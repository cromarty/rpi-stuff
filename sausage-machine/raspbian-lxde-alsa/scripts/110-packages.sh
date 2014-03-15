#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Installing some libraries and stuff necessary for the builds..."
apt-get -y -q install libasound2-plugins libportaudio2 portaudio19-dev libsonic0 libsonic-dev libdotconf-dev intltool libpulse-dev
echo "-- Running autoremove to remove unnecessary packages..."
apt-get -y -q autoremove
exit 0
