#!/bin/bash

set -e
echo '-- Adding espeak, speech-dispatcher and speechd-up to the IgnorePkg list in /etc/pacman.conf...'
sed -i 's:#IgnorePkg \+=:IgnorePkg = espeak speech-dispatcher speechd-up:'
echo '-- Finished adding to IgnorePkg directive'
exit 0
