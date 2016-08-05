#!/bin/bash

echo '-- Finished everything, removing the build path directory...'
[ "${TIDY}" ] && rm -rf "${BUILD_PATH}"
aplay /usr/share/sounds/sound-icons/trumpet-12.wav &>/dev/null
exit 0

