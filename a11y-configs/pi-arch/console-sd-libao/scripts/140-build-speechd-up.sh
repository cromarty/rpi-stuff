#!/bin/bash

set -e
pushd "${BUILD_PATH}"
echo '-- Building speechd-up...'
cat <<eof > PKGBUILD
# Maintainer:
pkgname=speechd-up
pkgver=0.4
pkgrel=1
arch=('i686' 'x86_64' 'armv6h')
pkgdesc="Connection between SpeakUp and speech-dispatcher"
url="http://www.freebsoft.org/speechd"
license=('GPL2' 'FDL')
provides=("speechd=\${pkgver}")
source=("http://devel.freebsoft.org/pub/projects/speechd-up/speechd-up-0.4.tar.gz")
        md5sums=('06d0f1014d776df524b03af640ce1144')

         build() {
  cd "\${srcdir}/\${pkgname}-\${pkgver}"
  
  ./configure --prefix=/usr --includedir=/usr/include/speech-dispatcher
  make all
  
}

package() {
  cd "\${srcdir}/\${_pkgname}-\${pkgver}"
  make DESTDIR="\${pkgdir}" install



}

eof

makepkg --asroot -i

exit 0
