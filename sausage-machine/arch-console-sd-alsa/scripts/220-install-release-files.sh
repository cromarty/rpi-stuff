#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Installing the README file, if it exists, to '/home/pi'..."
[ -f "${UTILS_PATH}/README" ] && install -m 644 "${UTILS_PATH}/README /home/pi
echo "-- Installing the motd file if it exists..."
[ -f "${UTILS_PATH}/motd" ] && install -m 644 "${UTILS_PATH}/motd" /etc/motd
exit 0

