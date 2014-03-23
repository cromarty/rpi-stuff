#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Creating and installing a dummy espeak package..."

# version for source got from repo
#VER=$(ls -d espeak-* | cut -f 2 --delimiter=-)

# version for source from sourceforge
VER=$(ls -d espeak-*-source | cut -f 2 --delimiter=-)

cat <<eof > espeak
Section: misc
Priority: optional
Standards-Version: 3.9.2

Package: espeak
Version: ${VER}
Maintainer: Mike Ray <mike@raspberryvi.org>
#Depends: none
Architecture: armhf
Description: Fake espeak package
 This is a fake package to let the packaging system
 believe that this Debian package is installed.
 .
 This is because espeak has been recompiled to make tweaks to latency
 parameters and we need to fool installation of other packages and meta-packages without
 their dependancies over-writing our tweaked espeak

eof

equivs-build espeak
PKG=$(ls espeak_*.deb)
dpkg --install "${PKG}"
echo "espeak hold" | dpkg --set-selections
exit 0



