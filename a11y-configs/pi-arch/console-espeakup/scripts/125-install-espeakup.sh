#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Installing espeakup...'
pacman -S --noconfirm --noprogressbar espeakup
echo '-- Finished installing espeakup'
exit 0
