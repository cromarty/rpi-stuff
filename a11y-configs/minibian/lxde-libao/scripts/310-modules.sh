#!/bin/bash
set -e
cd "${BUILD_PATH}"
echo "-- Inserting snd-bcm2835 and speakup_soft into /etc/modules..."
echo "snd-bcm2835" >> /etc/modules
echo "speakup_soft" >> /etc/modules
echo '-- Try to load the sound driver...'
set +e ; modprobe snd-bcm2835 ; set -e
echo '-- Completed module insertions'
exit 0
