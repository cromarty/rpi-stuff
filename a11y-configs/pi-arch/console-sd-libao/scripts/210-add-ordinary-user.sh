#!/bin/bash

SUPPL_GROUPS="audio,lp,storage,video,wheel,games,power"
[ $(cat /etc/group | grep brlapi | cut -f 1 -d: ) ] && SUPPL_GROUPS="${SUPPL_GROUPS},brlapi"

set -e
cd "${BUILD_PATH}"
echo "-- Adding ordinary user 'pi'..."
useradd -m -g users -G ${SUPPL_GROUPS} -s /bin/bash pi
echo -e "raspberry\nraspberry\n" | /usr/bin/passwd pi
echo "-- Added new user 'pi' successfully"

echo '-- Duplicating default speech-dispatcher configuration for user pi...'
mkdir -p /home/pi/.speech-dispatcher/conf
cp -r /etc/speech-dispatcher/* /home/pi/.speech-dispatcher/conf
chown -R pi:users /home/pi/.speech-dispatcher

exit 0

