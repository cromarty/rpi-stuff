#!/bin/bash

echo '-- Finalizing...'
echo "-- Removing the build directory ${BUILD_PATH}..."
rm -rf "${BUILD_PATH}"
aplay /usr/share/sounds/sound-icons/trumpet-12.wav &>/dev/null
echo '-- Finished finalizing'
exit 0

