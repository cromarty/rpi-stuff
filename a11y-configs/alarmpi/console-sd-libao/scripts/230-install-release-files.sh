#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Installing release files...' 
#[ -f "${RELEASE_PATH}/README" ] && install -m 644 -o pi -g users "${RELEASE_PATH}/README" /home/pi
install -m 644 -o pi -g users "${RELEASE_PATH}/*" /home/pi

echo "-- Installing the 'issue' file if it exists..."
[ -f "${RELEASE_PATH}/issue" ] && install -m 644 "${RELEASE_PATH}/issue" /etc/issue
echo '-- Finished installing release files'
exit 0

