#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Installing some libraries and stuff necessary for the builds, a lengthy process...'
apt-get -y -q install build-essential equivs devscripts alsa-utils libasound2-plugins libportaudio2 portaudio19-dev libsonic0 libsonic-dev libdotconf-dev intltool libpulse-dev libao4 libao-dev libao-common libsndfile1 libsndfile1-dev
echo '-- Running autoremove to remove unnecessary packages...'
apt-get -y -q autoremove
echo '-- Finished installing packages'
exit 0
