#!/bin/bash

PKGS=( libasound2-plugins libportaudio2 portaudio19-dev libsonic0 libsonic-dev libdotconf-dev intltool libpulse-dev )

check_errs() {
	# used for checking return value of function calls
	if [ "${1}" -ne "0" ]; then
		echo "-- Error : $0 : ${1} : ${2}" | tee -a script.result
		exit ${1}
	fi
} # check_errs

install_pkg() {
	echo "-- Installing ${1}..."
	apt-get install -y "${1}"
	check_errs $? "Failed installing ${1}"
} # install_pkg

install_packages() {
	echo "-- Installing packages..."
	for pkg in "${PKGS[@]}"
	do
		install_pkg "${pkg}"
	done
	apt-get autoremove
} # install_packages

if [ $(id -u) -ne 0 ]; then
	echo "-- Script must be run as root. Try 'sudo $0'"
	exit 1
fi

install_packages
check_errs $? "Failed to install packages"


echo "$0 completed successfully" | tee -a script.result

exit 0
