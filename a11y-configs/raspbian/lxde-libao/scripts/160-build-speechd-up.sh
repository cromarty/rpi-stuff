#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Building speechd-up..."
LOCAL_BUILD_PATH="speechd-up-0.4"
cd "${LOCAL_BUILD_PATH}"
./configure --prefix=/usr
make all
make install
exit 0


