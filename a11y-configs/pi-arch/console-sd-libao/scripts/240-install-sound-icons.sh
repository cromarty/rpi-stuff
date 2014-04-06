#!/bin/bash

pkgname=speechd-sound-icons
pkgver=0.1
pkgrel=1
arch=any
pkg="${SM_PACKAGE_PATH}/${pkgname}-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz"

set -e
cd "${BUILD_PATH}"
echo '-- Installing speech-dispatcher sound icons...'
echo '-- Checking whether we have a pre-built package...'
echo "-- Package name: ${pkg}"
if [ -f "${pkg}" ]; then
	echo '-- Found a pre-built package, installing it with pacman -U...'
	pacman -U --noconfirm --noprogressbar "${pkg}"
	echo '-- Finished installing the pre-built speechd sound icons package'
	exit 0
fi
echo '-- There was no pre-built package, creating it...'
mkdir -p sound-icons
pushd sound-icons >/dev/null
cat <<eof > PKGBUILD
# Maintainer:

pkgname=${pkgname}
pkgver=${pkgver}
pkgrel=1
pkgdesc="FreeBSoft sound icons for speech-dispatcher"
arch=("${arch}")
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

makepkg --asroot -i --noconfirm --noprogressbar
echo '-- Finished installing sound icons'
popd >/dev/null
if [ "${SM_TIDY}" ]; then
	rm -rf sound-icons
fi

exit 0
