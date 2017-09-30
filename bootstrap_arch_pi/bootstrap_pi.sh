#!/bin/bash

ARCHROOT=root

pacstrap -d ${ARCHROOT}" `cat package_list.txt`

# After the above:
#
# 1. arch-chroot
# 2. passwd root
# 3. set the hostname
# 4. Add another user
# 5. Enable sshd
# 6. Enable dhcpcd

