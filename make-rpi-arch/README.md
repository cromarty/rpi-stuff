
Script to make an Arch Image for Either ARMv6 or ARMv7
======================================================

The script `make-rpi-arch.sh` will create an image for either:

* ARMv6 - Original Raspberry Pi
* ARMv7 - Raspberry Pi version 2 and 3 (including Zero)

Needs:

* bsdtar
* kpartx
* losetup
* parted

See comment in top of script for usage.

Note Added in December 2016:

At the moment the files downloaded from archlinuxarm.org for the armv7 don't seem to result in a reliable boot.

So keep using armv6 until a later file system is up there than 12-December-2016.

