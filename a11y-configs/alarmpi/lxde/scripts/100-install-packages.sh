#!/bin/bash

set -e
echo '-- Installing LXDE and related stuff...'
sudo pacman -S --noconfirm --noprogressbar xorg-server xorg-xinit xorg-utils xorg-server-utils
sudo pacman -S --noconfirm --noprogressbar xf86-video-fbdev xf86-video-modesetting
pacman -S --noconfirm --noprogressbar libfm lxappearance lxappearance-obconf lxde-common lxde-icon-theme lightdm lxinput lxlauncher lxmenu-data lxmusic lxpanel lxpolkit lxsession lxtask lxterminal menu-cache openbox pcmanfm leafpad


echo '-- Setting up /home/pi/.xinitrc...'
install -m755 -o pi -g users /etc/skel/.xinitrc /home/pi
cat <<eof >> /home/pi/.xinitrc
exec startlxde

eof

install -m 755 "${CONFIG_PATH}/45accessibility /etc/X11/xinit/xinitrc.d
echo '-- Completed installation of LXDE'
exit 0
