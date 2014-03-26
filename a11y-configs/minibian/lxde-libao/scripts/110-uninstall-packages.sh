#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Removing a bunch of packages that are inaccessible by definition, graphical stuff etc..."
#apt-get remove --purge -y ace-of-penguins smartsim penguinspuzzle midori scratch mtpaint xfburn xfce4-power-manager xfce4-power-manager-data xfconf xpad
#apt-get autoremove --purge -y
#apt-get autoclean -y
echo '-- Finished removing packages'
exit 0

