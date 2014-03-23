#!/bin/bash



cd "${BUILD_PATH}"
echo "-- Enabling speech-dispatcher..."
# Enable speech-dispatcher at boot time
update-rc.d speech-dispatcher defaults
# Start it now
/etc/init.d/speech-dispatcher start
# Note: to remove speech-dispatcher from starting at boot up you would issue the following command:
# update-rc.d speech-dispatcher remove
exit 0


