#!/bin/bash
#
# Dependencies for package-query:
#     yajl
#

if [ `whoami` = 'root' ]; then
	echo "Script must NOT be run as root"
	exit 1
fi

set -e
git clone https://aur.archlinux.org/package-query.git
cd package-query
makepkg
