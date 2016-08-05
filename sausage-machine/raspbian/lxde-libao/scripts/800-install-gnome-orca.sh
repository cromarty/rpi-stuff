#!/bin/bash
set -e

cd "${BUILD_PATH}"
echo "-- Installing gnome-orca..."
apt-get -y -q install gnome-orca

echo '-- Creating some soft links to fool gtk module loading...'
ln -s arm-linux-gnueabihf/gtk-2.0 /usr/lib
ln -s arm-linux-gnueabihf/gtk-3.0 /usr/lib

echo '-- Installing /home/pi/.xsession...'
install -m 644 -o pi -g users ${CONFIG_PATH}/.xsession /home/pi

echo '-- Finished installing Orca'
exit 0
