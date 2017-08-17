#!/bin/bash

if [ `whoami` != 'root' ]; then
	echo 'Script must be run as root, try: $0'
	exit 1
fi

PREFIX=/usr/local/bin

install -m0755 imgtool ${PREFIX}
install -m644 imgtool.lib ${PREFIX}



