#!/bin/bash
set -e
cd "${BUILD_PATH}"
echo "-- Inserting speakup_soft into /etc/modules..."
echo "snd-bcm2835" >> /etc/modules
echo "speakup_soft" >> /etc/modules
exit 0
