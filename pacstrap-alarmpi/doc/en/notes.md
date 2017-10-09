
# General notes

## `pacstrap`

After using `pacstrap` to install the base group to either a directory 
or a mounted partition:


* Copy bootcode.bin, fixup*.dat, and start*.elf to the boot partition
* Add a line to /etc/fstab to mount boot partition
* Add dtparam=audio=on to /boot/config.txt
* Set root password
* Add a user
* Set user password
* Enable dhcpcd.service, sshd.service and any other services that are 
	needed from boot


## DHCPCD

Installing and enablind dhcpcd creates two files in /etc when the Pi is 
booted:

	/etc/dhcpcd.duid
	/etc/dhcpcd.secret

dhcpcd is now part of the base group.

## `chroot`

It is not possible to put variables on the right side of a `chroot` 
which have been named outside it.


