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


echo "-- Creating the speech-dispatcher user and it's home directory..."

echo '-- Creating the speech-dispatcher user...'
useradd --system \
	--comment 'speech-dispatcher' \ 
	--gid audio \
	--no-log-init \
	--no-user-group \
	--gecos 'speech-dispatcher' speech-dispatcher

exit 0


