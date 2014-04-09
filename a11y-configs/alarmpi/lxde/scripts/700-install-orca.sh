#!/bin/bash

set -e
echo '-- Installing orca...'
pacman -S --noconfirm --noprogressbar orca
echo '-- Completed installing orca'
exit 0
