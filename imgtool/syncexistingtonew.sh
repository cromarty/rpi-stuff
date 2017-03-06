#!/bin/bash

if [ `whoami` != 'root' ]; then
	echo "Script must be run as root, try: sudo $0"
	exit 1
fi

./imgsync.sh \
		--source-bootmp ./empty/bootmp \
		--source-rootmp ./empty/rootmp \
		--target-bootmp ./newempty/bootmp \
		--target-rootmp ./newempty/rootmp

