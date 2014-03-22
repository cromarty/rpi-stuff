#!/bin/bash

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result
echo "-- Creating and installing a dummy speech-dispatcher package..."

VER=$(ls -d speech-dispatcher-* | cut -f 3 --delimiter=-)

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
check_errs $? "Failed to build the dummy speech-dispatcher package"

PKG=$(ls speech-dispatcher_*.deb)

dpkg --install "${PKG}"
check_errs $? "Failed to install the dummy speech-dispatcher package"

echo "speech-dispatcher hold" | dpkg --set-selections
check_errs $? "Failed to hold the speech-dispatcher package"

echo "$0 Completed successfully" | tee -a script.result
exit 0

