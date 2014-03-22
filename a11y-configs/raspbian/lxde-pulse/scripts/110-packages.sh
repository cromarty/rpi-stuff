#!/bin/bash

. ./common-code

PKGS=( libasound2-plugins libportaudio2 portaudio19-dev libsonic0 libsonic-dev libdotconf-dev intltool libpulse-dev pulseaudio )
cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result
echo "-- Installing some libraries and stuff necessary for the builds..."

install_packages
check_errs $? "Failed to install packages"

echo "-- Running autoremove to remove unnecessary packages..."
apt-get -y -q autoremove
check_errs $? "Failed to autoremove"

echo "$0 Completed successfully" | tee -a script.result
exit 0
