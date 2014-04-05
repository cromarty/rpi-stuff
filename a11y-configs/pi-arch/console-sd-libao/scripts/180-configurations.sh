#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Installing some emacspeak stuff into /etc/skel...'
install -m644 ${CONFIG_PATH}/emacspeak/.emacs /etc/skel
mkdir -p /etc/skel/.emacs.d/elpa
install -m644 "${CONFIG_PATH}/emacspeak/package.el" /etc/skel/.emacs.d/elpa

echo '-- Installing speech-dispatcher configuration file in /etc/speech-dispatcher...'
install -m644 "${CONFIG_PATH}/speech-dispatcher/speechd.conf" /etc/speech-dispatcher
echo '-- Installing speechd-up.conf into /etc/speechd-up.conf...'
install -m644 "${CONFIG_PATH}/speechd-up/speechd-up.conf" /etc

echo '-- Duplicating default speech-dispatcher configuration for user pi...'
mkdir -p /home/pi/.speech-dispatcher/conf
cp -r /etc/speech-dispatcher/* /home/pi/.speech-dispatcher/conf
chown -R pi:users /home/pi/.speech-dispatcher

exit 0


