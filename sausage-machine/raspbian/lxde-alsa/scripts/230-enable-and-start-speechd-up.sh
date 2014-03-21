#!/bin/bash

cd "${BUILD_PATH}"
echo "-- Enabling and starting speechd-up..."
# Enable speechd-up at boot time
update-rc.d speechd-up defaults
# Start it now
/etc/init.d/speechd-up start
# Note: to remove speechd-up from starting at boot up you would issue the following command:
#update-rc.d speechd-up remove
exit 0


