#!/bin/bash

set -e
echo "-- Creating the 'wheel' group and granting sudo privileges to members of wheel..."
groupadd wheel
cat <<eof > /etc/sudoers.d/wheel
# grant privileges to members of 'wheel'
 %wheel ALL=(ALL) ALL
 
 eof
 echo '-- Finished granting sudo privileges to humble users'
 exit 0
