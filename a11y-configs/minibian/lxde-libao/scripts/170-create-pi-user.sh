#!/bin/bash

set -e
echo "-- Creating regular user 'pi'..."
useradd -m -g users -G adm,dialout,cdrom,wheel,audio,video,plugdev,games -s /bin/bash pi
echo -e "raspberry\nraspberry\n" | passwd pi 
echo "-- Created user 'pi' successfully"
exit 0
 
