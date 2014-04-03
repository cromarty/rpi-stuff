#!/bin/bash

set -e
echo '-- Installing brltty...'
echo '-- Checking whether we have a pre-built package...'
PBPKG=$( ls "${SM_PACKAGE_PATH}/brltty*.pkg.tar.xz" }
if [ "${PBPKG}" ]; then
	echo '-- Found a pre-built package, installing it with pacman -U...'
	pacman -U "${PBPKG}"
	echo '-- Finished installing the pre-built tclx package'
	exit 0
fi
echo '-- There was no pre-built package, building it...'
cd "${BUILD_PATH}"
echo '-- Installing brltty-minimal from the AUR...'
cower -d brltty-minimal
pushd brltty-minimal
echo "-- Adding 'armv6h' to the PKGBUILD file..."
sed -i-old "s:^arch=(\(.*\)):arch=(\1 'armv6h'):" PKGBUILD
makepkg --asroot -i --noconfirm --noprogressbar
echo '-- Finished installing brltty-minimal, tidying up...'
popd
if [ "${SM_TIDY}" ]; then
	set +e
	rm -rf brltty-minimal/
fi
exit 0

