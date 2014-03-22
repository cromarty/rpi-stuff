#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Checking to see if cower is installed..."
if [ $(which cower ]; then
	echo "-- cower is already installed"
	exit 0
fi

echo "-- Installing cower..."
wget https://aur.archlinux.org/packages/co/cower-git/cower-git.tar.gz
tar -zxf cower-git.tar.gz
cd cower-git
sed -i-old "s:^arch=(\(.*\)):arch=(\1 'armv6h'):" PKGBUILD
makepkg -s -i --asroot --noconfirm --noprogressbar
exit 0




