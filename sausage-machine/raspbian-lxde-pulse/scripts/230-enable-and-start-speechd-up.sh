#!/bin/bash

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result
echo "-- Enabling and starting speechd-up..."

# Enable speechd-up at boot time
#update-rc.d speechd-up defaults
echo "-- Currently speech-dispatcher is NOT started at boot"
check_errs $? "Failed to update the boot services"

# Start it now
/etc/init.d/speechd-up start
check_errs $? "Failed to start speechd-up"

# Note: to remove speechd-up from starting at boot up you would issue the following command:
# update-rc.d speechd-up remove

echo "$0 Completed successfully" | tee -a script.result
exit 0


