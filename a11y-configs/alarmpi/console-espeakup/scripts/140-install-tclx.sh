#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Checking to see if tclx is already installed...'
if [ $(which tclx) ]; then
	echo "-- tclx is already installed"
	exit 0
fi

echo '-- Installing tclx from the AUR...'
cower -d tclx
pushd tclx
echo "-- Adding 'armv6h' to the PKGBUILD architectures..."
sed -i-old "s:^arch=(\(.*\)):arch=(\1 'armv6h'):" PKGBUILD
makepkg -i --asroot --noconfirm --noprogressbar
echo '--Copying the omitted tclx library...'
cp -r pkg/usr/lib/tclx8.4/ /usr/lib
popd
echo '-- Finished installing tclx, tidying up...'
set +e
rm -rf tclx/
exit 0






