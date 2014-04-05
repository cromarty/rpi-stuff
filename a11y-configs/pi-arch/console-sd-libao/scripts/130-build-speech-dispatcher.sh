#!/bin/bash

pkgname=speech-dispatcher
pkgver=0.8
pkgrel=1
arch=armv6h
pkg="${SM_PACKAGE_PATH}/${pkgname}-${pkgver}-${pkgrel}-${arch}.tar.pkg.xz"

set -e
echo '-- Installing speech-dispatcher...'
echo '-- Checking whether we have a pre-built package...'
if [ -f "${pbk}" ]; then
	echo '-- Found a pre-built package, installing it with pacman -U...'
	pacman -U --noconfirm --noprogressbar "${pkg}"
	echo '-- Finished installing the pre-built speech-dispatcher package'
	exit 0
fi
echo '-- There was no pre-built package, building it...'
cd "${BUILD_PATH}"
echo '-- Building speech-dispatcher...'
mkdir speech-dispatcher
pushd speech-dispatcher >/dev/null
mkdir src
pushd src >/dev/null
cat <<eof > speech-dispatcherd.service
[Unit]
Description=Speech-Dispatcher an high-level device independent layer for speech synthesis.
After=syslog.target

[Service]
Type=forking
ExecStart=/usr/bin/speech-dispatcher -d 

[Install]
WantedBy=multi-user.target


eof

popd >/dev/null

cat <<eof > speech-dispatcher.install
info_dir=usr/share/info
info_files=('speech-dispatcher.info'
    'ssip.info'
    'spd-say.info')

post_install() {
  [[ -x usr/bin/install-info ]] || return 0
  for f in \${info_files[@]}; do
    install-info \${info_dir}/\$f.gz \${info_dir}/dir 2> /dev/null
  done
}

post_upgrade() {
  post_install
}

pre_remove() {
  [[ -x usr/bin/install-info ]] || return 0
  for f in \${info_files[@]}; do
    install-info --delete \${info_dir}/\$f.gz \${info_dir}/dir 2> /dev/null
  done
}


eof

cat <<eof > PKGBUILD
# Maintainer:
# Contributor:

pkgname=speech-dispatcher
pkgver=${pkgver}
pkgrel=${pkgrel}
arch=('${arch}')
pkgdesc="High-level device independent layer for speech synthesis interface without python"
url="http://www.freebsoft.org/speechd"
license=('GPL2' 'FDL')
depends=('glib2' 'libltdl' 'dotconf')
makedepends=('intltool')
provides=("speechd=\${pkgver}" "\$pkgname")
conflicts=("\$pkgname")
options=('!libtool') 
install="\${pkgname}.install"
source=("http://www.freebsoft.org/pub/projects/speechd/\$pkgname-\$pkgver.tar.gz")
md5sums=('d88691a64c676122f996230c107c392f')

build() {
  cd "\${srcdir}/\${pkgname}-\${pkgver}"
  
  ./configure --prefix=/usr \
	--includedir=/usr/include \
	--sysconfdir=/etc \
	--disable-static \
	--with-espeak \
	--without-flite \
	--without-ibmtts \
	--without-ivona \
	--without-pico \
	--without-pulse \
	--with-libao \
	--without-oss \
	--without-nas     

  make
}

package() {
  cd "\${srcdir}/\${pkgname}-\${pkgver}"
  make DESTDIR="\${pkgdir}" install

  install -Dm644 "\${srcdir}"/speech-dispatcherd.service "\${pkgdir}/usr/lib/systemd/system/speech-dispatcherd.service"
  install -d "\${pkgdir}/var/log/speech-dispatcher"
}

eof

makepkg --asroot -i --noconfirm --noprogressbar
ln -s /usr/include/speech-dispatcher/libspeechd.h /usr/include
echo '-- Finished building speech-dispatcher, tidying up...'
popd >/dev/null
if [ "${SM_TIDY}" ]; then
	set +e
	rm -rf speech-dispatcher
fi
exit 0
