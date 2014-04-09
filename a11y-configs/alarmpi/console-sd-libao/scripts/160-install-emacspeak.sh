#!/bin/bash
pkgname=emacspeak
pkgver=38.0
pkgrel=1
arch=armv6h
pkg="${PACKAGE_PATH}/${pkgname}-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz"

set -e
echo '-- Installing emacspeak...'
echo '-- Checking whether we have a pre-built package...'
echo "-- Package name: ${pkg}"
if [ -f "${pkg}" ]; then
	echo '-- Found a pre-built package, installing it with pacman -U...'
	pacman -U --noconfirm --noprogressbar "${pkg}"
	echo '-- Finished installing the pre-built emacspeak package'
	exit 0
fi
echo '-- There was no pre-built package, building it...'
cd "${BUILD_PATH}"
echo '-- Building and installing Emacspeak...'
echo '-- Checking to make sure Emacs is installed...'
if [ ! $(which emacs) ]; then
	echo '-- Emacs is not installed. Cannot proceed'
	exit 1
fi
mkdir emacspeak
pushd emacspeak >/dev/null
cat <<eof > emacspeak.install
INFO_DIR=/usr/share/info
info_files=(emacspeak)

post_install() {
  for f in \${info_files[@]}; do
    install-info \${INFO_DIR}/\$f.info.gz \${INFO_DIR}/dir 2> /dev/null
  done
}

post_upgrade() {
  post_install \$1
}

pre_remove() {
  for f in \${info_files[@]}; do
    install-info --delete \${INFO_DIR}/\$f.info.gz \${INFO_DIR}/dir 2> /dev/null
  done
}

eof

cat <<eof > PKGBUILD
# Maintainer:
pkgname=${pkgname}
pkgver=${pkgver}
pkgrel=${pkgrel}
pkgdesc="Emacs extension that provides spoken output"
arch=('${arch}')
url="http://emacspeak.sourceforge.net/"
license=('GPL' 'LGPL' 'APACHE')
depends=(emacs tcl tclx espeak)
optdepends=('eflite: software speech via the FLite TTS engine'
            'python: Google client, and wrapper for Emacspeak speech servers.')
install='emacspeak.install'
source=("http://\$pkgname.googlecode.com/files/\$pkgname-\$pkgver.tar.bz2")

build() {
	sed -i 's:, 512,:, 3072,:' \
		\${srcdir}/emacspeak-\${pkgver}/servers/linux-espeak/tclespeak.cpp


  cd "\$srcdir/\$pkgname-\$pkgver"
  sed -i -e 's, /etc/info-dir, \$(DESTDIR)/etc/info-dir,g' info/Makefile
  make config
  make

  # This one isn't compiled by default, but a lot of folks use it.
  cd servers/linux-espeak
  make TCL_VERSION=8.6
}

package() {
  cd "\$srcdir/\$pkgname-\$pkgver"
  install -dm755 "\$pkgdir/etc"
  make DESTDIR="\$pkgdir" install
  cd servers/linux-espeak
  make DESTDIR="\$pkgdir" install
  # Interestingly, the source files are installed under DESTDIR.
  cd "\$pkgdir/usr/share/emacs/site-lisp/emacspeak/servers/linux-espeak"
  rm -f tclespeak.cpp Makefile
  # A handful of files have permissions of 750 and 640; fix.
  cd "\$pkgdir"
  find . -perm 640 -print0
  find . -perm 750 -print0
  gzip -9nf "\${pkgdir}"/usr/share/info/*
  rm -f "\$pkgdir/usr/share/info/dir"
  rm -f "\$pkgdir/etc/info-dir"
}
sha1sums=('6433e16395a3b7ce1a90770856ee4f4d77e90a9b')

eof

makepkg -s -i --asroot --noconfirm --noprogressbar
echo '-- Editing the /usr/bin/emacspeak file to make it possible to save settings in local .emacs files...'
sed -i-old -e "s:\$HOME:~:" \
	-e "s:EMACS_UNIBYTE:#EMACS_UNIBYTE:" \
	-e "s:export EMACS_UNIBYTE:#export EMACS_UNIBYTE:" \
	-e "s:-q ::" /usr/bin/emacspeak

echo '-- Old emacspeak file saved in /usr/bin/emacspeak-old'
echo '-- Finished building emacspeak, tidying up...'
popd >/dev/null
if [ "${TIDY}" ]; then
	set +e
	rm -rf emacspeak/
fi
exit 0


