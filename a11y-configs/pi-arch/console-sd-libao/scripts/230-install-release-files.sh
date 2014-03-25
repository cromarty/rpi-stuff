#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Installing release files...' 
[ -f "${UTILS_PATH}/README" ] && install -m 644 "${UTILS_PATH}/README /home/pi
echo "-- Installing the 'issue' file if it exists..."
[ -f "${UTILS_PATH}/issue" ] && install -m 644 "${UTILS_PATH}/motd" /etc/issue
echo '-- Finished installing release files'
exit 0

