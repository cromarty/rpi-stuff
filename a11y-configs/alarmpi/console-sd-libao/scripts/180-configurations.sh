#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Installing some emacspeak stuff into /etc/skel...'
install -m644 ${CONFIG_PATH}/emacspeak/.emacs /etc/skel
mkdir -p /etc/skel/.emacs.d/elpa
install -m644 "${CONFIG_PATH}/emacspeak/package.el" /etc/skel/.emacs.d/elpa

echo '-- Installing speech-dispatcher configuration file in /etc/speech-dispatcher...'
install -m 644 "${CONFIG_PATH}/speech-dispatcher/speechd.conf" /etc/speech-dispatcher

echo '-- Installing speechd-up.conf into /etc/speechd-up.conf...'
install -m 644 "${CONFIG_PATH}/speechd-up/speechd-up.conf" /etc

echo '-- Installing speakupconf...'
install -m 755 "${UTILS_PATH}/speakupconf" /usr/bin


echo '-- Creating some soft links to fool sd...'
mkdir /usr/lib/arm-linux-gnueabihf
ln -s /usr/lib/speech-dispatcher-modules /usr/lib/arm-linux-gnueabihf
ln -s /usr/lib/ao /usr/lib/arm-linux-gnueabihf

echo '-- Removing some annoying and unnecessary sd modules...'
rm /usr/lib/speech-dispatcher-modules/sd_cicero
rm /usr/lib/speech-dispatcher-modules/sd_festival
rm /usr/lib/speech-dispatcher-modules/sd_generic

exit 0


