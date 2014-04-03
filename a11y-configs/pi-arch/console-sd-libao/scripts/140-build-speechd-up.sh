#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Building speechd-up...'
mkdir speechd-up
pushd speechd-up
mkdir src
pushd src
cat <<eof > speechd-upd.service
[Unit]
Description=speechd-up, a server to connect SpeakUp to speech-dispatcher
After=syslog.target

[Service]
Type=forking
ExecStart=/usr/bin/speechd-up -d

[Install]
WantedBy=multi-user.target

eof
popd

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
  
  ./configure --prefix=/usr
  make all
  
}

package() {
  cd "\${srcdir}/\${pkgname}-\${pkgver}"
  make DESTDIR="\${pkgdir}" install

	install -Dm644 "\${srcdir}"/speechd-upd.service "\${pkgdir}/usr/lib/systemd/system/speechd-upd.service"


}

eof

makepkg --asroot -i
echo '-- Finished building speechd-up'
popd
if [ "${SM_TIDY}" ]; then
	rm -rf speechd-up
fi

exit 0
