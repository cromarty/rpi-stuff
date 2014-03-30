#!/bin/bash

set -e
if [ ! -d "${BUILD_PATH}" ]; then
	echo '-- Makeing the build path'
	mkdir -p "${BUILD_PATH}"
fi

cd "${BUILD_PATH}"
echo '- Add sources repo to /etc/apt/sources.list...'
echo "deb-src http://archive.raspbian.org/raspbian wheezy main contrib non-free rpi" >> /etc/apt/sources.list
wget http://archive.raspbian.org/raspbian.public.key -O - | apt-key add -

## Add entries in /etc/apt/sources.list for Knoppix repos
#cat <<eof >> /etc/apt/sources.list
#
## KNOPPIX Sources
#deb-src http://debian-knoppix.alioth.debian.org ./
## KNOPPIX Precompiled binaries
#deb http://debian-knoppix.alioth.debian.org ./
#
#eof

apt-get update
echo '-- Finished preparation script'
exit 0

