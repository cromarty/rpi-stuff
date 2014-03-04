#!/bin/bash

PKGS=( equivs devscripts )

check_errs() {
	# used for checking return value of function calls
	if [ "${1}" -ne "0" ]; then
		echo "-- Error : $0 : ${1} : ${2}" | tee -a script.result
		exit ${1}
	fi
} # check_errs
source_list() {
	echo "-- Patch /etc/apt/source.list with sources repo stuff..."
	echo "deb-src http://archive.raspbian.org/raspbian wheezy main contrib non-free rpi" >> /etc/apt/sources.list
	wget http://archive.raspbian.org/raspbian.public.key -O - | apt-key add -
	apt-get update
	check_errs $? "Failed in source_list"
} # source_list


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
} # install_packages

if [ $(id -u) -ne 0 ]; then
	echo "-- Script must be run as root. Try 'sudo $0'"
	exit 1
fi
truncate -s 0 script.result
source_list
install_packages

echo "$0 completed successfully" | tee -a script.result

exit 0

