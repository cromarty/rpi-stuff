#!/bin/bash


if [ `whoami` = 'root' ]; then
	echo "Script must NOT be run as root"
	exit 1
fi

set -e

git clone https://aur.archlinux.org/yaourt.git
cd yaourt
makepkg
exit 0




