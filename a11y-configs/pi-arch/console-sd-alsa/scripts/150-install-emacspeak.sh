#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Checking to see if emacspeak is already installed..."
if [ $(which emacspeak) ]; then
	echo "-- Emacspeak is already installed"
	exit 0
fi

echo "-- Checking to make sure Emacs is installed..."
if [ ! $(which emacs) ]; then
	echo "-- Emacs is not installed. Can't proceed"
	exit 1
fi

echo "-- Getting the PKGBUILD with cower..."
cower -d emacspeak &&
echo "-- Adding 'armv6h' to the PKGBUILD architectures..."
sed -i-old "s:^arch=(\(.*\)):arch=(\1 'armv6h'):" PKGBUILD
makepkg -s -i --asroot --noconfirm --noprogressbar
echo "-- Editing the /usr/bin/emacspeak file to make it possible to save settings in local .emacs files..."
sed -i-old -e "s:\$HOME:~:" \
	-e "s:EMACS_UNIBYTE:#EMACS_UNIBYTE:" \
	-e "s:export EMACS_UNIBYTE:#export EMACS_UNIBYTE:" \
	-e "s:-q ::" /usr/bin/emacspeak

echo "-- Old emacspeak file saved in /usr/bin/emacspeak-old"
exit 0


