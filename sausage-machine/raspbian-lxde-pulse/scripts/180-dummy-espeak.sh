#!/bin/bash

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result
echo "-- Creating and installing a dummy espeak package..."

VER=$(ls -d espeak-* | cut -f 2 --delimiter=-)

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
check_errs $? "Failed to build the dummy espeak package"

PKG=$(ls espeak_*.deb)
dpkg --install "${PKG}"
check_errs $? "Failed to install the dummy espeak package"

echo "espeak hold" | dpkg --set-selections
check_errs $? "Failed to hold the espeak package"

echo "$0 Completed successfully" | tee -a script.result
exit 0



