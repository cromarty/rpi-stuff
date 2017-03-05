#!/bin/bash
pkgname=tclx
pkgver=8.4
pkgrel=1
arch=armv6h
pkg="${PACKAGE_PATH}/${pkgname}-${pkgver}-${pkgrel}-${arch}.pkg.tar.xz"

set -e
echo '-- Installing tclx...'
echo '-- Checking whether we have a pre-built package...'
echo "-- Package name: ${pkg}"
if [ -f "${pkg}" ]; then
	echo '-- Found a pre-built package, installing it with pacman -U...'
	pacman -U --noconfirm --noprogressbar "${pkg}"
	echo '-- Finished installing the pre-built tclx package'
	exit 0
fi
echo '-- There was no pre-built package, building it...'
cd "${BUILD_PATH}"
echo '-- Installing tclx...'
mkdir tclx
pushd tclx >/dev/null
cat <<eof > PKGBUILD
# Maintainer:
# Contributor:
pkgname=${pkgname}
pkgver=${pkgver}
_tclsrcver=8.4.12
pkgrel=${pkgrel}
pkgdesc="Provides OS primitives, file scanning, data records etc. for Tcl"
url="http://tclx.sourceforge.net"
arch=('${arch}')
license="BSD"
depends=('tcl' 'tk')
source=("http://downloads.sourceforge.net/sourceforge/tclx/tclx\${pkgver}.tar.bz2" \
	"http://downloads.sourceforge.net/sourceforge/tcl/tcl\${_tclsrcver}-src.tar.gz")
md5sums=('395c2fbe35e1723570b005161b9fc8f8' '7480432d8730263f267952788eb4839b')

build() {
	cd \$startdir/src/tclx\${pkgver}
	#[ "\$NOEXTRACT" == 1 ] || patch < \$startdir/configure.patch
	cp /usr/lib/tclConfig.sh ..
	echo "TCL_SRC_DIR=\$startdir/src/tcl\$_tclsrcver" >> ../tclConfig.sh
	[ "\$NOEXTRACT" == 1 ] || ./configure --prefix=/usr --enable-share \
		--enable-gcc --with-tcl=\$startdir/src
	_tclsrc="TCL_SRC_DIR=\$startdir/src/tcl\$_tclsrcver \
	TCL_TOP_DIR_NATIVE=\$startdir/src/tcl\$_tclsrcver"
	make \$_tclsrc || return 1
	make \$_tclsrc prefix=\$startdir/pkg/usr \
		exec_prefix=\$startdir/pkg/usr install

}

eof

makepkg -s -i --asroot --noconfirm --noprogressbar

cp -r ${BUILD_PATH}/tclx/pkg/usr/lib/tclx8.4/ /usr/lib

echo '-- Finished building tclx, tidying up...'
popd >/dev/null
if [ "${TIDY}" ]; then
	set +e
	rm -rf tclx/
fi
exit 0





