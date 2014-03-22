#!/bin/bash

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result
echo "-- Creating and installing a dummy speechd-up package..."

VER=0.4

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
check_errs $? "Failed creating dummy speechd-up package"

dpkg --install speechd-up_${VER}_armhf.deb
check_errs $? "Failed to install the dummy speechd-up package"

echo "speechd-up hold" | dpkg --set-selections
check_errs $? "Failed to hold the speechd-up package"

echo "$0 Completed successfully" | tee -a script.result
exit 0

