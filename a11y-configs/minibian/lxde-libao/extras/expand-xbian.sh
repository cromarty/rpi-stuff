#!/bin/bash

# change this to your device
DEVICE=/dev/sdc

set -e

if [ $(id -u) -ne 0 ]; then
	echo "Script must be run as root. Try: 'sudo $0'"
	exit 1
fi

# Check that parted is installed.
# It is needed for getting start and end points of partitions.
which parted &> /dev/null
if [ $? -ne "0" ]; then
	echo "parted is not installed. Script will exit"
	exit 1
fi

# Get the start of the root partition in sectors
PART2_START=$(parted -ms ${DEVICE} unit s p | grep "^2" | cut -f 2 -d: | cut -f 1 -ds)

fdisk ${DEVICE} <<EOF
p
d
2
n
p
2
${PART2_START}
+2800MB
p
w
EOF

sync;sync;sync
e2fsck -f /dev/sdc2
resize2fs /dev/sdc2
sync;sync;sync
exit 0







