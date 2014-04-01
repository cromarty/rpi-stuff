#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Creating and installing a dummy speechd-up package..."
VER=$(ls -d speechd-up*/ | sed 's:/::' | cut -f 3 -d-)

cat <<eof > speechd-up
Section: misc
Priority: optional
Standards-Version: 3.9.2

Package: speechd-up
Version: ${VER}
Maintainer: Mike Ray <mike@raspberryvi.org>
#Depends: none
Architecture: armhf
Description: Fake speechd-up package
 This is a fake package to let the packaging system
 believe that speechd-up is installed
 .
 This is because speechd-up has been recompiled
 and we need to fool other packages and meta-packages
 into not installing speechd-up and thus
 over-writing our recompiled version

eof

equivs-build speechd-up
dpkg --install speechd-up_${VER}_armhf.deb
echo "speechd-up hold" | dpkg --set-selections
exit 0

