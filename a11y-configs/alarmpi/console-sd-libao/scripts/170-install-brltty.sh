#!/bin/bash
pkgname=brltty-minimal
pkgver=5.0
pkgrel=1
arch=armv6h
pkg="${PACKAGE_PATH}/${pkgname}-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz"

set -e
echo '-- Installing brltty...'
echo '-- Checking whether we have a pre-built package...'
echo "-- Package name: ${pkg}"
if [ -f "${pkg}" ]; then
	echo '-- Found a pre-built package, installing it with pacman -U...'
	pacman -U --noconfirm --noprogressbar "${pkg}"
	echo '-- Finished installing the pre-built brltty package'
	exit 0
fi
echo '-- There was no pre-built package, building it...'
cd "${BUILD_PATH}"
mkdir brltty-minimal
pushd brltty-minimal >/dev/null
mkdir src
pushd src >/dev/null
cat <<eof > brltty.service
[Unit]
Description=Braille Console Driver
DefaultDependencies=no
Before=sysinit.target

[Service]
ExecStart=/usr/bin/brltty --pid-file=/run/brltty.pid
Type=forking
PIDFile=/run/brltty.pid

[Install]
WantedBy=sysinit.target

eof

popd >/dev/null

cat <<eof > brltty.install
post_install () {
     getent group brlapi  &>/dev/null || groupadd -r brlapi
     if [ ! -e /etc/brlapi.key ]; then
         mcookie >/etc/brlapi.key
         chmod 0640 /etc/brlapi.key
         chgrp brlapi /etc/brlapi.key
         echo "Please add your user to the brlapi group."
     fi
}

post_upgrade () {
    post_install
}

post_remove () {
    getent group brlapi >/dev/null 2>&1 && groupdel brlapi
    if [ -e /etc/brlapi.key ]; then
        rm -f /etc/brlapi.key
    fi
}

eof

cat <<eof > PKGBUILD
# Maintainer:
pkgname=${pkgname}
pkgver=${pkgver}
pkgrel=${pkgrel}
pkgdesc="Braille display driver for Linux/Unix"
arch=(${arch})
url="http://mielke.cc/brltty"
license=(GPL LGPL)
depends=(bash icu)
conflicts=('brltty')
provides=('brltty')
backup=(etc/brltty.conf)
options=('!emptydirs')
install=brltty.install
source=(http://mielke.cc/brltty/archive/brltty-\${pkgver}.tar.gz)
md5sums=('48742d2992f2027dcc1c330ad42c0c71')

build() {
  cd "\${srcdir}/brltty-\${pkgver}"
  ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
    --mandir=/usr/share/man \
    --with-tables-directory=/usr/share/brltty \
    --with-screen-driver=lx \
    --disable-gpm \
    --disable-speech-support \
    --disable-java-bindings \
    --disable-python-bindings \
    --disable-tcl-bindings \
    --disable-caml-bindings \
    --disable-static

  make
}

package() {
  cd "\${srcdir}/brltty-\${pkgver}"
  make INSTALL_ROOT="\$pkgdir" install
  install -Dm644 Documents/brltty.conf "\$pkgdir/etc/brltty.conf"
  install -Dm644 ../brltty.service "\$pkgdir/usr/lib/systemd/system/brltty.service"
}


eof

makepkg --asroot -i --noconfirm --noprogressbar
echo '-- Finished installing brltty-minimal, tidying up...'
popd >/dev/null
if [ "${TIDY}" ]; then
	set +e
	rm -rf brltty-minimal/
fi
exit 0

