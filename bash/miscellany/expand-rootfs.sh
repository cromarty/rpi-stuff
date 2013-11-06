#!/bin/sh
#
# Run this after first login.  Deletes and re-creates the root partition.
# Reboot after running this script and then run resize-rootfs.sh to do the actual resize.
# Must be run as root.
#
# No guarantee of fitness for purpose given or implied.
# Mike Ray, June 2013
#

if [ $(id -u) -ne 0 ]; then
    echo "Script must be run as root. Try 'sudo ./expand-rootfs.sh'"
    exit 1
    fi

  # Get the starting offset of the root partition
PART_START=$(parted /dev/mmcblk0 -ms unit s p | grep "^2" | cut -f 2 -d:)
[ "$PART_START" ] || return 1
# Return value will likely be error for fdisk as it fails to reload the 
# partition table because the root fs is mounted
fdisk /dev/mmcblk0 <<EOF
p
d
2
n
p
2
$PART_START

p
w
EOF


echo "You must now reboot.  After you have logged in again, run resize-rootfs.sh"


