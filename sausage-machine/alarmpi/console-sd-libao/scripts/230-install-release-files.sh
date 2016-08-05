#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Installing release files...' 
pushd "${RELEASE_PATH}" >/dev/null
for RF in *
do
	install -m 644 -o pi -g users "${RF}" /home/pi
done
popd >/dev/null

echo "-- Installing the 'issue' file if it exists..."
[ -f "${RELEASE_PATH}/issue" ] && install -m 644 "${RELEASE_PATH}/issue" /etc/issue
echo '-- Finished installing release files'
exit 0

