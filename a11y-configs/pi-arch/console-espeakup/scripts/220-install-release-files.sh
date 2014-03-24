#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Installing release files, including the README file, if it exists, to /home/pi...'
[ -f "${UTILS_PATH}/README" ] && install -m 644 "${UTILS_PATH}/README" /home/pi
echo '-- Installing the issue file if it exists...'
[ -f "${CONFIG_PATH}/etc/issue" ] && install -m 644 "${CONFIG_PATH}/etc/issue" /etc/issue
echo '-- Finished installing release files'
exit 0

