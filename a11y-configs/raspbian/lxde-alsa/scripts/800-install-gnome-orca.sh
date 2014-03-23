#!/bin/bash
set -e

cd "${BUILD_PATH}"
echo "-- Installing gnome-orca..."
apt-get -y -q install gnome-orca
exit 0
