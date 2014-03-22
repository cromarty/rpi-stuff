#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Installing root file-system expansion scripts to /home/pi..."
install -m755 "${UTILS_PATH}/expand-arch-rootfs-2.0.sh /home/pi
install -m755 "${UTILS_PATH}/resize-arch-rootfs-2.0.sh /home/pi
exit 0

