#!/bin/bash

set -e
echo '-- Installing LXDE and related stuff...'
sudo pacman -S --noconfirm --noprogressbar xorg-server xorg-xinit xorg-utils xorg-server-utils 
sudo pacman -S --noconfirm --noprogressbar xorg-xinit xorg-xclock xorg-twm xterm
sudo pacman -S --noconfirm --noprogressbar xf86-video-fbdev 
sudo pacman -S --noconfirm --noprogressbar lxde

echo '-- Setting up /home/pi/.xinitrc...'
cat <<eof > /home/pi/.xinitrc

exec startlxde

eof

echo '-- Completed installation of LXDE'
exit 0
