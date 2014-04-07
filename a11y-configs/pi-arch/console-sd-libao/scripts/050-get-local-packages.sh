#!/bin/bash

set -e
echo "-- Getting packages from: ${PACKAGE_URL}..."
cd "${SM_PACKAGE_PATH}"

wget http://${PACKAGE_URL}/get-packages.sh
chmod +x get-packages.sh

./get-packages.sh

echo "-- Finished getting packages from ${PACKAGE_URL}"
exit 0



