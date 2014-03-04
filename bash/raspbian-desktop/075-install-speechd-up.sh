#!/bin/bash

check_errs() {
	# used for checking return value of function calls
	if [ "${1}" -ne "0" ]; then
		echo "-- Error ${1} : ${2}" | tee -a script.result
		exit ${1}
	fi
} # check_errs


if [ $(id -u) -ne 0 ]; then
	echo "-- Script must be run as root. Try 'sudo $0'"
	exit 1
fi

apt-get install speechd-up
check_errs $? "Failed installing speechd-up"

echo "$0 Completed successfully" | tee -a script.result

exit 0


