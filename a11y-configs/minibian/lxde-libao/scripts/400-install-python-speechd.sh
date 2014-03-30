#!/bin/bash


set -e

cd "${BUILD_PATH}"
echo "-- Installing python-speechd..."
apt-get -y -q install python-speechd
exit 0
