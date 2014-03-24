#!/bin/bash

set -e

if [ ! -d "${BUILD_PATH}" ]; then
	mkdir -p "${BUILD_PATH}"
fi

cd "${BUILD_PATH}"
echo '-- Updating Arch...'
pacman -Sy
echo '-- Finished updating Arch'
exit 0

