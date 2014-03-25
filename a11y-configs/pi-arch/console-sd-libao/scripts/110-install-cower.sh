#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Checking to see if cower is installed...'
if [ $(which cower ]; then
	echo '-- cower is already installed'
	exit 0
fi

echo '-- Installing cower...'
wget https://aur.archlinux.org/packages/co/cower-git/cower-git.tar.gz
tar -zxf cower-git.tar.gz
pushd cower-git
sed -i-old "s:^arch=(\(.*\)):arch=(\1 'armv6h'):" PKGBUILD
makepkg -i --asroot --noconfirm --noprogressbar
echo '-- Finished making and installing cower, tidying up...' 
popd
set +e
rm -rf cower-git/
exit 0




