#!/bin/bash

DEVICE=/dev/mmcblk0

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

which bc &> /dev/null
if [ $? -ne "0" ]; then
	echo "bc is not installed. Script will exit"
	exit 1
fi

# Get the size of the media in megabytes
MB=$(parted ${DEVICE} -ms unit MB p | grep "^/" | cut -f 2 -d: | cut -dM -f 1)

# Get the start of the root partition in sectors
PART_START=$(parted -ms ${DEVICE} unit s p | grep "^2" | cut -f 2 -d: | cut -f 1 -ds)

# Get the start of logical partition 5 in sectors
LOG_START=$(parted -ms ${DEVICE} unit s p | grep "^5" | cut -f 2 -d: | cut -f 1 -ds)

# Calculate the end of the partition in extra megabytes.
# We leave about 30 megabytes spaceat the end so that backups and restores
# from backed up .img files work correctly.
MB_END=$(echo "${MB} - 120" | bc | cut -f 1 -d.)

echo "Size of device in megabytes: ${MB}"
echo "Start of partition 2: ${PART_START}"
echo "Start of logical partition 5: ${LOG_START}"
echo "New size of root partition: ${MB_END}"

fdisk ${DEVICE} <<EOF
p
d
2
n
e
2
${PART_START}
+${MB_END}MB
n
l
${LOG_START}

p
w
EOF

echo "Now reboot, log in again as root and then run resize-arch-rootfs-2.0.sh"







