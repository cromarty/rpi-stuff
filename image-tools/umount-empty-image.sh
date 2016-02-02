#!/bin/bash

if [ `whoami` != 'root' ]; then
	echo 'Script must be run as root'
	exit 1
fi

WRK=work

set -e

cd ${WRK}

echo 'Reading mount-points...'
cat mount-points | \
while read MP
do
	echo "umounting ${MP}"
	umount ${MP}
	echo "Removing the directory ${MP}"
	rmdir ${MP}
done

echo 'Reading loop-dev-names...'
cat loop-dev-names | \
while read LOOP
do
	echo "Removing ${LOOP}"
	dmsetup remove ${LOOP}
done

echo 'Removing the mount-points file...'
rm mount-points
echo 'Removing the loop-dev-names file...'
rm loop-dev-names

echo 'Finished'

exit 0

