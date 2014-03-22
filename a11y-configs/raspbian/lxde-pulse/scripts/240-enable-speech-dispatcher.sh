#!/bin/bash

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result
echo "-- Enabling speech-dispatcher..."

# Enable speech-dispatcher at boot time
update-rc.d speech-dispatcher defaults
check_errs $? "Failed to update the boot services"

# Start it now
#/etc/init.d/speech-dispatcher start
#check_errs $? "Failed to start speechd-up"

# Note: to remove speech-dispatcher from starting at boot up you would issue the following command:
# update-rc.d speech-dispatcher remove

echo "$0 Completed successfully" | tee -a script.result
exit 0


