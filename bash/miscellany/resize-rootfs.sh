#!/bin/sh
#
# Run this after running expand-rootfs.sh and rebooting.
#
# It will expand the root file system to fill your memory card.
# Must be run as troot.
#
# No guaranttee of fitness for purpose given or implied.
# Mike Ray, June 2013
#
if [ $(id -u) -ne 0 ]; then
    echo "Script must be run as root. Try 'sudo ./resize-rootfs.sh'"
    exit 1
    fi

resize2fs /dev/mmcblk0p2

