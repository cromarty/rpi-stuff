#!/bin/bash

if [ `whoami` != 'root' ]; then
	echo "Script must be run as root, try: sudo $0"
	exit 1
fi

./imgsync.sh \
		--source-bootmp ./existing/bootmp \
		--source-rootmp ./existing/rootmp \
		--target-bootmp ./empty/bootmp \
		--target-rootmp ./empty/rootmp

