#!/bin/bash

find $1 -type s -print > /tmp/sockets-to-exclude

tar cvpzf \
	backup.tgz \
	-X /tmp/sockets-to-exclude \
	--exclude=$1/proc \
	--exclude=$1/lost+found  \
	--exclude=$1/tmp \
	--exclude=/$1/mnt \
	--exclude=$1/sys $1 \
	> mylog.txt
