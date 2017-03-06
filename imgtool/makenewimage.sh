#!/bin/bash

if [ `whoami` != 'root' ]; then
	echo "Script must be run as root, try sudo $0"
	exit 1
fi

IMG=$(date +%F)-empty.img

./imgtool.sh -w newempty \
-f new \
-i ${IMG} \
  -c 3000 \
-z 1M \
-s 64



