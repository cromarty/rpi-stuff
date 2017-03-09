
imgtool
=======

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
* Un-mount both partitions of both .img files, remove the associated loop devices and remove the 
mount points.

Usage
-----

There are multiple arguments required by the script, some of which are mandatory, and some are 
optional.

To see usage:

	./imgtool.sh -h

Note that using the `-h` or `--help` argument is the only example in which the script can be used 
without `sudo`.

imgsync.sh
==========

This script will use `rsync` to copy files from the boot and root partitions of a mounted image file 
to boot and root mount-point directories.

The target directories can either be just plain directories or the boot and root partitions of 
another (probably new empty image created with imgtool.sh) and then mounted.

In this way this script can be used to copy from one Raspberry Pi image to another.

If the target directories are just directories and not a mounted image file's partitions, then it is 
effectively backing up the contents of the source image.

Workflow Examples
=================

Example 1
---------

Create and mount a new `.img` file.

Run `imgtool.sh` like this:

	sudo ./imgtool.sh -w mynewimage -i mynewimage.img -c 3000 -f new

The above command will create a working directory called `mynewimage` in which a `.img` file will be 
created called `mynewimage.img`. The new image will be 3000 blocks in length and the default 
block-size of `1M` has been used (the -z argument was not given). The FAT32 boot partition will be 
64 blocks in size, which is the default value, as the -s argument for `split` was also not given.

The arguments for the boot and root mount-points use the defaults (bootmp and rootmp) because these 
arguments (-b and -r) were also not given.

So after the command completes there will be a directory called:

	mynewimage/

In which there will be two directories:

	bootmp/
	rootmp/

And the image file:

	mynewimage.img

The two partitions contained in the file will be mounted at the two mount-points.

* The FAT32 boot partition on mynewimage/bootmp
* The ext4 root partition on mynewimage/rootmp

In addition there will be two files in the `mynewimage/` working directory which will be used when 
the script is used to clean-up behind itself. These files are:

	mount-points
	loop-dev-names

Example 2
---------

Mount an existing `.img` file.

To mount a pre-existing `.img` file use `imgtool.sh` like this:

	sudo ./imgtool.sh -w existingimage -i mynewimage -f mount

In the above command the working directory `existingimage` will be created and the pre-existing 
image `mynewimage` will be mounted. Again in this case the boot and root mount-points will have the 
default values of `bootmp` and `rootmp` respectively.

And again in the working directory the two files:

	mount-points
	loop-dev-names

Will be created for the script to use when it cleans up.

Example 3
---------

To clean-up with the script, which does these things:

* Un-mount both partitions of  mounted image file
* Remove both the loop devices which were used when the image was mounted
* Remove the mount-point directories
* Delete the `mount-points` and `loop-dev-names` files

Run the script like this:

	sudo ./imgtool.sh -w mynewimage -f cleanup

This will clean-up behind the image we created and mounted in workflow example 1.

Note that it *does not* either delete the `.img` file or remove the working directory.

So you will still have:

	mynewimage/mynewimage.img

Example 4
---------

Using `imgsync.sh` to copy from one image to either another (empty) mounted image or to two simple 
directories.

This example assumes you have:

* Used `imgtool.sh` to mount an existing image
* Used `imgtool.sh` to create a new image with sufficient partition sizes to receive all files from 
the first one

We will assume the working directory given to the script to mount the existing image is:

	myexistingimage

And the working directory given to the script in which to create and mount the new empty image is:

	mynewimage

As before, when the script was run both to mount the existing image and to create the new one, the 
defaults were accepted for the names of the mount-points.

So this structure exists:

	myexistingimage/
		bootmp/
		rootmp/

	mynewimage/
		bootmp/
		rootmp/

The script `imgsync.sh` needs eight arguments to use `rsync` to copy the contents of one to the 
other. These arguments are:

* --source-bootmp
* --source-rootmp
* --target-bootmp
* --target-rootmp

Hopefully the name of each argument is self-explanatory.

Note that the working directories need to be explicitly given to each argument.

The command-line will be very long so I have given it below with backslash line continuations and 
spread it over multiple lines:

	sudo ./imgsync.sh --source-bootmp myexistingimage/bootmp \
		--source-rootmp myexistingimage/rootmp \
		--target-bootmp mynewimage/bootmp \
		--target-rootmp mynewimage/rootmp

The script will then use two `rsync` commands to copy from boot partition to boot partition and from 
root partition to root partition.

Of course the script will fail if you did not create the new image large enough to receive the files 
from the existing one.





