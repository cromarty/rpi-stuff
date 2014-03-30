#!/bin/bash

# Must be run with sudo -E

set -e
cd "${BUILD_PATH}"
echo "-- Setting up configuration stuff for speechd-up..."

# /etc stuff
install -m 755 ${CONFIG_PATH}/init.d/speechd-up /etc/init.d
install -m 644 ${CONFIG_PATH}/default/speechd-up /etc/default
install -m 644 ${CONFIG_PATH}/speechd-up.conf /etc/speechd-up.conf
echo '-- Finished configuring speechd-up'
exit 0
