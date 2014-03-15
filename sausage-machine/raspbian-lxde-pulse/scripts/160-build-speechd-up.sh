#!/bin/bash

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result
echo "-- Building speechd-up..."

LOCAL_BUILD_PATH="speechd-up-0.4"

cd "${LOCAL_BUILD_PATH}"

./configure --prefix=/usr
check_errs $? "Failed in ./configure"

make all
check_errs $? "Failed in make"

make install
check_errs $? "Failed in make install"

echo "$0 Completed successfully" | tee -a script.result
exit 0


