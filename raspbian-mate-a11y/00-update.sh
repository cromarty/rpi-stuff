#!/bin/bash

if [ `whoami` != 'root' ]; then
	echo "Script must be run as root. Try sudo $0"
	exit 1
fi

echo 'Performing an update...'
apt-get -yq update
echo 'Done'

exit 0

