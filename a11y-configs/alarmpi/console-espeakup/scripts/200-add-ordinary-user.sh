#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Adding ordinary user 'pi'...'
useradd -m -g users -G audio,lp,storage,video,wheel,games,power,brlapi -s /bin/bash pi
echo -e "raspberry\nraspberry\n" | /usr/bin/passwd pi
echo "-- Added new user 'pi' successfully"
exit 0

