#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Installing some emacspeak stuff into /etc/skel...'
install -m644 ${CONFIG_PATH}/emacspeak/.emacs /etc/skel
mkdir -p /etc/skel/.emacs.d/elpa
install -m644 "${CONFIG_PATH}/emacspeak/package.el /etc/skel/.emacs.d/elpa
echo '-- Finished installing emacspeak files to /etc/skel'
exit 0


