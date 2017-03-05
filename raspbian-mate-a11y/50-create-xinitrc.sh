#!/bin/bash

if [ `whoami` = 'root' ; then
	echo "Don't run this script as root. Script will exit.'
	exit 1
fi

echo 'Writing user .xinitrc...'
echo -e "\n\nexec mate-session\n\n" > ~/.xinitrc

echo 'Done'
exit 0

