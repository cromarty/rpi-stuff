#!/bin/bash

if [ `whoami` != 'root' ]; then
	echo 'Script must be run  as root'
	exit 1
fi

set -e

apt-get -y update

exit 0
