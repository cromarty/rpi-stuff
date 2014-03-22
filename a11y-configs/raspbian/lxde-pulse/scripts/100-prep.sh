#!/bin/bash

. ./common-code

PKGS=( equivs devscripts )

source_list() {
	echo "-- Patch /etc/apt/source.list with sources repo stuff..."
	echo "deb-src http://archive.raspbian.org/raspbian wheezy main contrib non-free rpi" >> /etc/apt/sources.list
	wget http://archive.raspbian.org/raspbian.public.key -O - | apt-key add -
	apt-get update
	check_errs $? "Failed in source_list"
} # source_list


cd "${BUILD_PATH}" || exit 1

kill `pgrep raspi-config`
rm /etc/profile.d/raspi-config.sh

truncate -s 0 "${PROGLOG}"

echo "Starting $0..." | tee -a script.result

source_list
install_packages

echo "$0 Completed successfully" | tee -a script.result
exit 0

