#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Installing cower...'
wget https://aur.archlinux.org/packages/co/cower-git/cower-git.tar.gz
tar -zxf cower-git.tar.gz
pushd cower-git >/dev/null
sed -i-old "s:^arch=(\(.*\)):arch=(\1 'armv6h'):" PKGBUILD
makepkg -i --asroot --noconfirm --noprogressbar
popd >/dev/null
echo '-- Finished making and installing cower, tidying up...' 
if [ "${TIDY}" ]; then
	set +e
	rm -rf cower-git/
	rm cower-git.tar.gz
fi

exit 0



