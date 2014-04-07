#!/bin/bash

pkgname=espeak
pkgver=1.48.04
pkgrel=1
arch=armv6h
pkg="${SM_PACKAGE_PATH}/${pkgname}-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz"


set -e
echo '-- Checking whether we have a pre-built package...'
echo "-- Package name: ${pkg}"
if [ -f "${pkg}" ]; then
	echo '-- Found a pre-built package, installing it with pacman -U...'
	pacman -U --noconfirm --noprogressbar "${pkg}"
	echo '-- Finished installing the pre-built espeak package'
	exit 0
fi
echo '-- There was no pre-built package, building it...'
cd "${BUILD_PATH}"
echo '-- Building espeak from source...'
mkdir -p espeak
pushd espeak >/dev/null
cat <<eof > PKGBUILD
# Maintainer:

pkgname=${pkgname}
pkgver=${pkgver}
pkgrel=${pkgrel}
pkgdesc="Text to Speech engine for good quality English, with support for other languages"
arch=('${arch}')
url="http://espeak.sourceforge.net/"
license=('GPL')
depends=('gcc-libs' 'portaudio')
conflicts=("\${pkgname}")
provides=("${pkgname}")
source=(http://downloads.sourceforge.net/sourceforge/\${pkgname}/\${pkgname}-\${pkgver}-source.zip)
md5sums=('cadd7482eaafe9239546bdc09fa244c3')

build() {
	cd \${startdir}/src/\${pkgname}-\${pkgver}-source/src
	cp portaudio19.h portaudio.h

	#sed -i -e 's:#define FRAMES_PER_BUFFER 512:#define FRAMES_PER_BUFFER 2048:' wave.cpp
	#sed -i -e 's:paFramesPerBufferUnspecified:FRAMES_PER_BUFFER:' wave.cpp
	#sed -i -e 's:(double)0.1:(double)0.2:' wave.cpp
	#sed -i -e 's:double aLatency = deviceInfo->defaultLowOutputLatency:double aLatency = deviceInfo->defaultHighOutputLatency:' wave.cpp

	make all CXXFLAGS="$CXXFLAGS"
}

package() {
  cd \${startdir}/src/\${pkgname}-\${pkgver}-source/src
  make DESTDIR=\${pkgdir} install
  chmod 644 \${pkgdir}/usr/lib/libespeak.a
  install -m 755 speak /usr/bin
  cd \${startdir}/src/\${pkgname}-\${pkgver}-source
  install -Dm644 License.txt "\${pkgdir}/usr/share/licenses/\${pkgname}/LICENSE"
}

eof

makepkg --asroot -i --noprogressbar --noconfirm
echo '-- Finished building and installing espeak, tidying up...'
popd >/dev/null
if [ "${SM_TIDY}" ]; then
	set +e
	rm -rf espeak/
fi
exit 0
