#!/bin/bash

set -e
echo '-- Installing emacspeak...'
echo '-- Checking whether we have a pre-built package...'
PBPKG=$( ls "${SM_PACKAGE_PATH}/emacspeak*.pkg.tar.xz" }
if [ "${PBPKG}" ]; then
	echo '-- Found a pre-built package, installing it with pacman -U...'
	pacman -U "${PBPKG}"
	echo '-- Finished installing the pre-built tclx package'
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

echo '-- Getting the PKGBUILD with cower...'
cower -d emacspeak
pushd emacspeak
echo "-- Adding 'armv6h' to the PKGBUILD architectures..."
sed -i-old "s:^arch=(\(.*\)):arch=(\1 'armv6h'):" PKGBUILD
makepkg -s -i --asroot --noconfirm --noprogressbar
echo '-- Editing the /usr/bin/emacspeak file to make it possible to save settings in local .emacs files...'
sed -i-old -e "s:\$HOME:~:" \
	-e "s:EMACS_UNIBYTE:#EMACS_UNIBYTE:" \
	-e "s:export EMACS_UNIBYTE:#export EMACS_UNIBYTE:" \
	-e "s:-q ::" /usr/bin/emacspeak

echo '-- Old emacspeak file saved in /usr/bin/emacspeak-old'
echo '-- Finished building emacspeak, tidying up...'
popd
if [ "${SM_TIDY}" ]; then
	set +e
	rm -rf emacspeak/
fi
exit 0


