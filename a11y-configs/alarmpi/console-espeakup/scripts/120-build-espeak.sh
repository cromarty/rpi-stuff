#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Building espeak from source...'
mkdir -p espeak
pushd espeak
cat <<eof > PKGBUILD
# Maintainer:

pkgname=espeak
pkgver=1.48.04
pkgrel=1
pkgdesc="Text to Speech engine for good quality English, with support for other languages"
arch=('armv6h')
url="http://espeak.sourceforge.net/"
license=('GPL')
depends=('gcc-libs' 'portaudio')
conflicts=("${pkgname}")
provides=("${pkgname}")
source=(http://downloads.sourceforge.net/sourceforge/\${pkgname}/\${pkgname}-\${pkgver}-source.zip)
#md5sums=('281f96c90d1c973134ca1807373d9e67')
md5sums=('cadd7482eaafe9239546bdc09fa244c3')

build() {
	cd \${startdir}/src/\${pkgname}-\${pkgver}-source/src
	cp portaudio19.h portaudio.h
#	sed -i -e 's:#define FRAMES_PER_BUFFER 512:#define FRAMES_PER_BUFFER 2048:' \
#		-e 's:paFramesPerBufferUnspecified:FRAMES_PER_BUFFER:' \
#		-e 's:(double)0.1:(double)0.4:' \
#		-e 's:double aLatency = deviceInfo->defaultLowOutputLatency:double aLatency = deviceInfo->defaultHighOutputLatency:' wave.cpp

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
popd
echo '-- Finished building and installing espeak, tidying up...'
set +e
rm -rf espeak/
exit 0
