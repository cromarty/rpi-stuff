#!/bin/bash

. ./common-code

PKGS=( gnome-orca )

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result
echo "-- Installing gnome-orca..."

install_packages
check_errs $? "Failed installing orca"

echo "$0 Completed successfully" | tee -a script.result
exit 0
