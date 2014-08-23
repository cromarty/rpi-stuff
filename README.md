### rpi-stuff

Here's what is in this repo:

* a11y-configs/

Contains a mechanism for runnings series of scripts in order of name.

The groups of scripts relate mostly to accessibility.

In the top-level directory there is a scripts called generate-run-scripts.sh, 
which generates a script in each of the sub-sub directories to run the script 
groups.  For example it will generate a script in:

alarmpi/console-sd-libao

Called console-sd-libao.run.sh, which will run the scripts in that group.

Each 'group contains some sub-directories which relate to the group to be run:

config
scripts
utils

Within each sub-directory of a11y-configs you will find another README, and so 
on down the tree.

* bash/

General stuff.

* file-conv-utils/

Utilities for converting files from one flavour to another.

* music-utils/

As above but specific to music.

* notes/

See if you can guess?

