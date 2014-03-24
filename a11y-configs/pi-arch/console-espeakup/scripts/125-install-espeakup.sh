#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Installing espeakup..."
pacman -S --noconfirm --noprogressbar espeakup
exit 0
