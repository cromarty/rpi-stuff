#!/bin/bash

set -e
echo '-- Installing LXDE and related stuff...'
sudo pacman -S --noconfirm --noprogressbar xorg-server xorg-xinit xorg-utils xorg-server-utils 
sudo pacman -S --noconfirm --noprogressbar xf86-video-fbdev 
pacman -S --noconfirm --noprogressbar libfm lxappearance lxappearance-obconf lxde-common lxde-icon-theme lightdm lxinput lxlauncher lxmenu-data lxmusic lxpanel lxpolkit lxsession lxtask lxterminal menu-cache openbox pcmanfm
pacman -S --noconfirm --noprogressbar leafpad

echo '-- Setting up /home/pi/.xinitrc...'
cat <<eof > /home/pi/.xinitrc

exec startlxde

eof

echo '-- Completed installation of LXDE'
exit 0
