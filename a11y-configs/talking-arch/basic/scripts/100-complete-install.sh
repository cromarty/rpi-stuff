#!/bin/bash

set -e
echo 'Setting up localisation stuff...'
sed -i 's:#en_GB:en_GB:' /etc/locale.gen
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
 export LANG=en_GB.UTF-8
ln -s /usr/share/zoneinfo/Europe/London /etc/localtime

echo 'Setting the hardware clock...'
hwclock —systohc —utc

echo 'Setting the hostname...'
hostnamectl set-hostname archiso

echo 'Setting the password for root...'
echo -e "root\nroot\n" | passwd root

echo 'Adding an ordinary user...'
useradd -m -g users -G wheel,storage,power -s /bin/bash username
echo -e "password\npassword\n" username

echo 'Installing sudo...'
pacman -S sudo
echo 'Editing /etc/sudoers to grant the usual privileges...'
sed -i 's:# %wheel ALL=(ALL) ALL: %wheel ALL=(ALL) ALL:' /etc/sudoers
echo 'Installing grub...'
pacman -S grub-bios
echo 'Setting up grub...'
 grub-install —target=i386-pc —recheck /dev/sda
 cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg

echo 'Setting some stuff in /etc/hosts.allow...'
echo 'SSHD: ALL' >> /etc/hosts.allow

echo 'Enabling the sshd service...'
systemctl enable sshd.service

echo 'Enabling the dhcpcd service...'
systemctl enable dhcpcd.service

echo 'Enabling the espeak service...'
systemctl enable espeakup.service

echo 'Saving alsa settings...'
alsactl -f /var/lib/alsa/asound.state store

echo 'About to exit chroot...'
exit

echo 'un-mounting hard-disk partitions from virtual mount point...'
 umount /mnt/home
 umount /mnt
 
 echo 'Rebooting...'
 
 reboot
