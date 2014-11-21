#!/bin/bash

# Where we do the builds
BUILD_PATH=~/.builds

check_errs() {
	# used for checking return value of function calls
	if [ "${1}" -ne "0" ]; then
		echo "Error ${1} : ${2}"
		exit ${1}
	fi
} # check_errs

pkgbuild_edit() {
	echo "-- Editing PKGBUILD to add 'armv6h'..."
	sed -i-old "s:^arch=(\(.*\)):arch=(\1 'armv6h'):" PKGBUILD
	check_errs $? "Failed in pkgbuild_edit"
} # pkgbuild_edit

install_cower() {
	echo "Checking to see if cower is installed..."
	which cower &> /dev/null
	if [ $? -eq 0 ]; then
		echo "cower is already installed"
		return 0
	fi
	echo "Installing cower..."
	wget https://aur.archlinux.org/packages/co/cower-git/cower-git.tar.gz &&
	tar -zxf cower-git.tar.gz &&
	cd cower-git &&
	pkgbuild_edit &&
	makepkg -s -i --asroot --noconfirm --noprogressbar
	check_errs $? "failed in install_cower"
	echo "Successfully installed cower"
} # install_cower


if [ $(id -u) -ne 0 ]; then
	echo "Must be root to install cower"
	exit 1
fi

install_cower

exit 0


