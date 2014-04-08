#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Updating Arch...'
pacman -Sy
echo '-- Finished updating Arch'
exit 0
