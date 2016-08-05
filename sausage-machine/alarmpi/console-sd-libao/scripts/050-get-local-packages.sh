#!/bin/bash

set -e
echo "-- Getting packages from: ${PACKAGE_URL}..."
cd "${PACKAGE_PATH}"

wget http://${PACKAGE_URL}/get-packages.sub

[ -f "./get-packages.sub" ] && . "./get-packages.sub"

echo "-- Finished getting packages from ${PACKAGE_URL}"
exit 0



