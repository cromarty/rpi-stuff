#!/bin/bash
#
# Generate a list of all Arch Linux installed packages
# and display on stdout
#

set -e

pacman -Qe | awk '{print $1}' > package_list.txt

exit 0

