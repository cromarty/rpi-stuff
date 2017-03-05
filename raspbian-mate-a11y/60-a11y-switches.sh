#!/bin/bash

if [ `whoami` = 'root' ]; then
	echo "Don't run this script as root, script will exit."
	exit 1
fi

set -e

echo 'The accessibility switches are currently:'
gsettings get org.mate.interface accessibility
gsettings get org.gnome.desktop.a11y.applications screen-reader-enabled

echo 'Setting accessibility switches...'	
dbus-launch gsettings set org.mate.interface accessibility true
	dbus-launch gsettings set org.gnome.desktop.a11y.applications screen-reader-enabled true

echo 'The accessibility switches are now:'
gsettings get org.mate.interface accessibility
gsettings get org.gnome.desktop.a11y.applications screen-reader-enabled

exit 0

