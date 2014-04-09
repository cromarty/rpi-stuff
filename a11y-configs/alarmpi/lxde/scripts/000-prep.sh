#!/bin/bash

set -e
echo '-- Updating Arch...'
pacman -Sy --noconfirm --noprogressbar
echo '-- Finished updating Arch'
exit 0
