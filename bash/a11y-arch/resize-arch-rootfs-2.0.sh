#!/bin/bash

DEVICE=/dev/sdc

if [ $(id -u) -ne 0 ]; then
	echo "Script must be run as root. Try: 'sudo $0'"
	exit 1
	fi

resize2fs "${DEVICE}"


