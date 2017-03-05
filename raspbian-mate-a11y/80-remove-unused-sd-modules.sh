#!/bin/bash

if [ `whoami` != 'root' ]; then
echo 'Script must be run as root'
exit 1
fi


echo 'Removing unused speech-dispatcher modules...'
rm /usr/lib/speech-dispatcher-modules/sd_cicero
rm /usr/lib/speech-dispatcher-modules/ sd_flite
rm /usr/lib/speech-dispatchcer-modules/sd_generic

echo 'Done'

exit 0
