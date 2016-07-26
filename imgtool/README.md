
imgtool.sh
==========

imgtool.sh will do the following:

* Create an empty .img file with two partitions, one which is FAT32, and the second which is ext4.
* Create loop devices and mount the two partitions somewhere in the file-system of the host Linux 
machine.

Or:

* Create loop devices and mount the two partitions of an existing Raspberry Pi image, such as a 
Raspbian image.

It will also clean up after itself, un-mounting the two partitions, removing the loop devices and 
removing the mount points.

In this way it is possible, among other things to:

* Create a new empty .img file
* Mount both partitions of that file
* Mount both partitions of an existing Raspberry Pi image
* Use rsync to copy files from the existing Raspberry Pi image to the empty one
* Un-mount both partitions of both .img files, remove the associated loop devices and remove the 
mount points.

You will then have a new .img file with the same files as the old one.

So, if you have an SD card on which you have expanded the file system to fit the whole card, say a 
16GB card, but there are still only about 3GB of files, you can shrink it down into a new smaller 
.img file again.

Or just use it to back up all of the files into a .tar.gz.

Usage
-----

There are multiple arguments required by the script, some of which are mandatory, and some are 
optional.

To see usage:

	sudo ./imgtool.sh -h

Sudo is required 





