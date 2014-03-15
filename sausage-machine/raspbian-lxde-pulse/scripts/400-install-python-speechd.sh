#!/bin/bash

. ./common-code

PKGS=( python-speechd )

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result
echo "-- Installing python-speechd..."

install_packages

echo "$0 Completed successfully" | tee -a script.result
exit 0
