#!/bin/bash
set -e

cd "${BUILD_PATH}"
wget http://devel.freebsoft.org/pub/projects/sound-icons/sound-icons-0.1.tar.gz
mkdir -p -m 755 /usr/share/sounds/sound-icons
tar -xzf ${B{BUILD_PATH}/sound-icons-0.1.tar.gz
install -t /usr/share/sounds/sound-icons sound-icons-0.1/*
exit 0



