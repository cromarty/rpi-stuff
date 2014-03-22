#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Updating Arch..."
pacman -Sy
exit 0

