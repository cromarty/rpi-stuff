#!/bin/bash

set -e
cd "${BUILD_PATH}"
## get the source
wget http://devel.freebsoft.org/pub/projects/speechd-up/speechd-up-0.4.tar.gz
tar -xzvf speechd-up-0.4.tar.gz
## build
echo "-- Building speechd-up..."
LOCAL_BUILD_PATH="speechd-up-0.4"
pushd "${LOCAL_BUILD_PATH}"
./configure --prefix=/usr
sed -i-old 's:ret = spd_set_capital_letters://ret = spd_set_capital_letters:' speechd-up.c
make all
make install
popd
echo '-- Finished building speechd-up'
exit 0


