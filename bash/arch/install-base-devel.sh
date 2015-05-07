#!/bin/bash

# The base-devel package is split into it's member packages here for restarting purposes to avoid re-installing those already installed.
BASE_DEVEL=( autoconf automake binutils bison fakeroot file findutils flex gawk gcc gettext grep groff gzip libtool m4 make pacman patch pkg-config sed sudo texinfo util-linux which )

check_errs() {
	# used for checking return value of function calls
	if [ "${1}" -ne "0" ]; then
		echo "Error ${1} : ${2}"
		exit ${1}
	fi
} # check_errs

install_pkg() {
	echo "Checking whether ${1} is already installed..."
	if [ ! -z "$(pacman -Ss $1 | grep "/$1 " | grep '[i]nstalled')" ]; then
		echo "${1} is already installed, continuing with the next package"
		return 0
	fi
	echo "Installing ${1}..."
	pacman -S --noconfirm --noprogressbar "${1}"
	check_errs $? "Failed installing ${1}"
} # install_pkg


install_base_devel() {
	echo "Installing packages from base-devel..."
	for pkg in "${BASE_DEVEL[@]}"
	do
		install_pkg "${pkg}"
	done
} # install_base_devel


if [ $(id -u) -ne 0 ]; then
	echo "Must be run as root"
	exit 1
fi

install_base_devel

exit 0

