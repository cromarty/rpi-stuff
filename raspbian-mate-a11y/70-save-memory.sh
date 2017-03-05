#!/bin/bash

if `whoami` = 'root' ]; then
echo "Don't run this script as root. Script will exit'
exit 1
fi

set -e

echo 'Remove icons from menus and buttons...'
	dbus-launch gsettings set org.mate.interface menus-have-icons false
	dbus-launch gsettings set org.mate.interface buttons-have-icons false


echo 'Done'

exit 0
