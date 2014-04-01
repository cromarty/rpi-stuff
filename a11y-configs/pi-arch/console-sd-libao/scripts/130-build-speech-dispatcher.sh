#!/bin/bash

set -e
pushd "${BUILD_PATH}"
echo '-- Building speech-dispatcher...'
mkdir -p speech-dispatcher
pushd speech-dispatcher
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
pkgver=0.8
pkgrel=1
arch=('i686' 'x86_64' 'armv6h')
pkgdesc="High-level device independent layer for speech synthesis interface without python"
url="http://www.freebsoft.org/speechd"
license=('GPL2' 'FDL')
depends=('glib2' 'libltdl' 'dotconf')
makedepends=('intltool')
provides=("speechd=\${pkgver}" "\$pkgname")
conflicts=("\$pkgname")
options=('!libtool') 
install="\${pkgname}.install"
source=("http://www.freebsoft.org/pub/projects/speechd/\$pkgname-\$pkgver.tar.gz"
	'speech-dispatcherd.service')
md5sums=('d88691a64c676122f996230c107c392f'
	'd26f52e2e95a30eaa83560f0e63faca5')

build() {
  cd "\${srcdir}/\${pkgname}-\${pkgver}"
  
  ./configure --prefix=/usr \
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

makepkg --asroot -i
popd
popd
echo '-- Finished building speech-dispatcher'
exit 0
