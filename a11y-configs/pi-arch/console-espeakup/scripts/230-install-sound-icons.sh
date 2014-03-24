#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Installing the speech-dispatcher sound icons from FreeBSoft...'
wget http://devel.freebsoft.org/pub/projects/sound-icons/sound-icons-0.1.tar.gz
mkdir -p -m 755 /usr/share/sounds/sound-icons
tar -xzf ${BUILD_PATH}/sound-icons-0.1.tar.gz
install -t /usr/share/sounds/sound-icons sound-icons-0.1/*
echo '-- Finished installing the speech-dispatcher sound-icons'
exit 0



