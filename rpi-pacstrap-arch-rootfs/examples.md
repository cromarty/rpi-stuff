
# `rpi-pacstrap-arch-rootfs.lib` Function Calls Examples

## Include the Library

	. ./rpi-pacstrap-arch-rootfs.lib

Remember to set the path properly

## Add a new User

	chroot_add_user <chroot> <username>

## Change Password

	chroot_passwd <chroot> <username> <password>

## Set Host Name

	chroot_set_hostname <chroot> <host name>

## Get List of Installed Packages

	get_installed_package_list <file name>

