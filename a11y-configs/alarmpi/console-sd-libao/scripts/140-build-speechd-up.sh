#!/bin/bash

pkgname=speechd-up
pkgver=0.4
pkgrel=1
arch=armv6h
pkg="${PACKAGE_PATH}/${pkgname}-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz"

set -e
echo '-- Installing speechd-up...'
echo '-- Checking whether we have a pre-built package...'
echo "-- Package name: ${pkg}"
if [ -f "${pkg}" ]; then
	echo '-- Found a pre-built package, installing it with pacman -U...'
	pacman -U --noconfirm --noprogressbar "${pkg}"
	echo '-- Finished installing the pre-built speechd-up package'
	exit 0
fi
echo '-- There was no pre-built package, building it...'
cd "${BUILD_PATH}"
echo '-- Building speechd-up...'
mkdir speechd-up
pushd speechd-up >/dev/null
mkdir src
pushd src >/dev/null
cat <<eof > speechd-upd.service
[Unit]
Description=speechd-up, a server to connect SpeakUp to speech-dispatcher
After=syslog.target

[Service]
Type=forking
ExecStart=/usr/lib/systemd/scripts/speechd-upd

[Install]
WantedBy=multi-user.target

eof

popd >/dev/null

cat <<eof > PKGBUILD
# Maintainer:
pkgname=${pkgname}
pkgver=${pkgver}
pkgrel=${pkgrel}
arch=('${arch}')
pkgdesc="Connection between SpeakUp and speech-dispatcher"
url="http://www.freebsoft.org/speechd"
license=('GPL2' 'FDL')
provides=("speechd=\${pkgver}")
source=("http://devel.freebsoft.org/pub/projects/speechd-up/speechd-up-0.4.tar.gz")
        md5sums=('06d0f1014d776df524b03af640ce1144')

         build() {
  cd "\${srcdir}/\${pkgname}-\${pkgver}"
  
  ./configure --prefix=/usr
    #sed -i-old 's:SPD_CAP_SPELL:SPD_CAP_NONE:' speechd-up.c
    sed -i-old 's:ret = spd_set_capital_letters://ret = spd_set_capital_letters:' speechd-up.c
  make all
  
}

package() {
  cd "\${srcdir}/\${pkgname}-\${pkgver}"
  make DESTDIR="\${pkgdir}" install

	install -Dm644 "\${srcdir}"/speechd-upd.service "\${pkgdir}/usr/lib/systemd/system/speechd-upd.service"


}

eof

makepkg --asroot -i --noconfirm --noprogressbar
echo '-- Finished building speechd-up'
popd >/dev/null
if [ "${TIDY}" ]; then
	rm -rf speechd-up
fi

exit 0
