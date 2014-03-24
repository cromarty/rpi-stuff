#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Updating Arch..."
exit 0
pacman -Sy --noconfirm --noprogressbar
exit 0

