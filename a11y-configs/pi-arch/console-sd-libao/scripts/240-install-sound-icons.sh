#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Installing speech-dispatcher sound icons...'
mkdir -p sound-icons
pushd sound-icons
cat <<eof > PKGBUILD
# Maintainer:

pkgname=speechd-sound-icons
pkgver=0.1
pkgrel=1
pkgdesc="FreeBSoft sound icons for speech-dispatcher"
arch=(any)
url="http://devel-freebsoft.org/"
license=('GPL2')
source=("http://devel.freebsoft.org/pub/projects/sound-icons/sound-icons-0.1.tar.gz")
md5sums=('2777d1ec18854230dce51fb75490c26e')

build() {
	mkdir -p -m 755 /usr/share/sounds/sound-icons
	tar -xzf sound-icons-0.1.tar.gz
	install -t /usr/share/sounds/sound-icons sound-icons-0.1/* 
}

eof

makepkg --asroot -i
echo '-- Finished installing sound icons'
popd
if [ "${SM_TIDY}" ]; then
	rm -rf sound-icons
fi

exit 0
