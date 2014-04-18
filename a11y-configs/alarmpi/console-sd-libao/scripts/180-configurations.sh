#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Editing /etc/sudoers to grant usual privileges...'
sed -i 's:# %wheel ALL=(ALL) ALL: %wheel ALL=(ALL) ALL:' /etc/sudoers

echo '-- Installing some emacspeak stuff into /etc/skel...'
install -m644 ${CONFIG_PATH}/emacspeak/.emacs /etc/skel
mkdir -p /etc/skel/.emacs.d/elpa
install -m644 "${CONFIG_PATH}/emacspeak/package.el" /etc/skel/.emacs.d/elpa

echo '-- Installing speech-dispatcher configuration file in /etc/speech-dispatcher...'
install -m 644 "${CONFIG_PATH}/speech-dispatcher/speechd.conf" /etc/speech-dispatcher
echo '-- Installing espeak.conf in /etc/speech-dispatcher/modules...'
rm -f /etc/speech-dispatcher/modules/*.conf
install -m 644 "${CONFIG_PATH}/speech-dispatcher/modules/espeak.conf" /etc/speech-dispatcher/modules

echo '-- Installing speechd-up.conf into /etc/speechd-up.conf...'
install -m 644 "${CONFIG_PATH}/speechd-up/speechd-up.conf" /etc

echo '-- Installing speakupconf...'
install -m 755 "${UTILS_PATH}/speakupconf" /usr/bin

echo '-- Installing the systemd script that is called from speechd-upd.service...'
install -m 755 "${CONFIG_PATH}/speechd-up/speechd-upd" /usr/lib/systemd/scripts

#echo '-- Setting up the speech-dispatcher user...'
#useradd -m -N -d /var/run/speech-dispatcher \
#	-g audio -c "speech-dispatcher server" -s /bin/false speech-dispatcher


echo '-- Creating some soft links to fool sd...'
mkdir /usr/lib/arm-linux-gnueabihf
ln -s /usr/lib/speech-dispatcher-modules /usr/lib/arm-linux-gnueabihf
ln -s /usr/lib/ao /usr/lib/arm-linux-gnueabihf

echo '-- Removing some annoying and unnecessary sd modules...'
rm /usr/lib/speech-dispatcher-modules/sd_cicero
rm /usr/lib/speech-dispatcher-modules/sd_festival
rm /usr/lib/speech-dispatcher-modules/sd_generic

exit 0


