#!/bin/bash

set -e
echo '-- Installing stuff for LXDE...'
pacman -S --noconfirm --noprogressbar libfm lxappearance lxappearance-obconf lxde-common lxde-icon-theme lxdm lxinput lxlauncher lxmenu-data lxmusic lxpanel lxpolkit lxsession lxtask lxterminal menu-cache openbox pcmanfm
echo '-- Completed installing packages'
exit 0

