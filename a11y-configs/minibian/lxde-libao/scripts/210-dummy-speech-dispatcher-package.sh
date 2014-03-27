#!/bin/bash
set -e
cd "${BUILD_PATH}"
echo "-- Creating and installing a dummy speech-dispatcher package..."

VER=$(ls -d */ | sed 's:/::' | grep speech-dispatcher | cut -f 3 -d-)

cat <<eof > speech-dispatcher
Section: misc
Priority: optional
Standards-Version: 3.9.2

Package: speech-dispatcher
Version: ${VER}
Maintainer: Mike Ray <mike@raspberryvi.org>
#Depends: none
Architecture: armhf
Description: Fake speech-dispatcher package
 This is a fake package to let the packaging system
 believe that this Debian package is installed.
 .
 This is because speech-dispatcher has been recompiled for alsa support
 and we need to fool other packages and meta-packages
 into not installing speech-dispatcher and thus
 over-writing our recompiled version

eof

equivs-build speech-dispatcher
PKG=$(ls speech-dispatcher_*.deb)
dpkg --install "${PKG}"
echo "speech-dispatcher hold" | dpkg --set-selections
exit 0

