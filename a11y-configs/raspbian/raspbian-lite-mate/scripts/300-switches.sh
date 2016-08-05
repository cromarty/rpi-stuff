#!/bin/bash
#
# 1. Set the gsettings switches for the normal user
#

if [ `whoami` = 'root' ]; then
	echo 'Do not run this script as root'
	exit 1
fi

set -i

dbus-launch gsettings set org.mate.interface accessibility true
dbus-launch gsettings set org.gnome.desktop.a11y.applications screen-reader-enabled true

exit 0

