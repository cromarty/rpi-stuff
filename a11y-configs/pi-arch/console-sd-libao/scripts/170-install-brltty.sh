#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Installing brltty-minimal from the AUR...'
cower -d brltty-minimal
pushd brltty-minimal
echo "-- Adding 'armv6h' to the PKGBUILD file..."
sed -i-old "s:^arch=(\(.*\)):arch=(\1 'armv6h'):" PKGBUILD
makepkg --asroot -i --noconfirm --noprogressbar
echo '-- Finished installing brltty-minimal, tidying up...'
popd
if [ !${SM_TIDY}" ]; then
	set +e
	rm -rf brltty-minimal/
fi
exit 0

