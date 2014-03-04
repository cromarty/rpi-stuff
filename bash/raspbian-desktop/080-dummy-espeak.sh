#!/bin/bash

check_errs() {
	# used for checking return value of function calls
	if [ "${1}" -ne "0" ]; then
		echo "-- Error : $0 : ${1} : ${2}" | tee -a script.result
		exit ${1}
	fi
} # check_errs

VER=$(ls -d espeak-* | cut -f 2 --delimiter=-)

cat <<eof > espeak
Section: misc
Priority: optional
Standards-Version: 3.9.2

Package: espeak
Version: ${VER}
Maintainer: Mike Ray <mike@raspberryvi.org>
Depends: none
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
check_errs $? "Failed to build the package"

PKG=$(ls espeak_*.deb)
dpkg --install "${PKG}"
check_errs $? "Failed to install the dummy package"

echo "$0 compleeted successfully" | tee -a script.result

exit 0



