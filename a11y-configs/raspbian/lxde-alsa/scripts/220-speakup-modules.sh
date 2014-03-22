#!/bin/bash
set -e
cd "${BUILD_PATH}"
echo "-- Inserting speakup_soft into /etc/modules..."
echo "speakup_soft" >> /etc/modules
exit 0
