#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Installing the espeakup.service file...'
install -m644 "${CONFIG_PATH}/espeakup/espeakup.service" /usr/lib/systemd/system/espeakup.service
echo '-- Finished installing the espeakup.service file'
exit 0
