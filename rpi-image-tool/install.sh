#!/bin/bash

if [ `whoami` != 'root' ]; then
	echo 'Script must be run as root, try: $0'
	exit 1
fi

PREFIX=/usr/local/bin



[ -d /usr/share/rpi-image-tool ] || mkdir /usr/share/rpi-image-tool
install -m0644 rpi-image-tool.lib /usr/share/rpi-image-tool

install -m0755 rpi-image-tool ${PREFIX}
install -m755 rpi-image-sync ${PREFIX}



