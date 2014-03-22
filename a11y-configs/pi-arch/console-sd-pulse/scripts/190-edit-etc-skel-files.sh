#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Adding 'export DTK_PROGRAM=espeak' to /etc/skel.bashrc..."
cat <<eof >> /etc/skel/.bashrc

export DTK_PROGRAM=espeak

eof

exit 0



