#!/bin/bash

set -e
echo '-- Setting localisation/timezone Europe/London...'
sed -i 's:#en_GB.UTF-8:en_GB.UTF-8' /etc/locale.gen
locale-gen
localectl set-locale LANG="en_GB.UTF-8"
timedatectl set-timezone Europe/London
timedatectl set-ntp 1
echo '-- Localisation changes will take effect on the next reboot'
echo '-- Finished setting up localisation'
exit 0
