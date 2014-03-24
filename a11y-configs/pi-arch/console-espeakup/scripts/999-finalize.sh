#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Finalizing...'
set +e
aplay /usr/share/sounds/sound-icons/trumpet-12.wav &>/dev/null
echo '-- Finished finalizing'
exit 0

