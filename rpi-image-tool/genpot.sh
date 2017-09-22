#!/bin/bash


       xgettext -L Shell -o - rpi-image-tool rpi-image-sync backuppi | \
sed -e 's|YEAR|2017|' \
-e 's|=CHARSET|=UTF-8|' \
-e 's|SOME DESCRIPTIVE TITLE|rpi-image-tools|' \
-e "s|THE PACKAGE'S COPYRIGHT HOLDER|Mike Ray|" \
-e 's|FIRST AUTHOR|Mike Ray|' \
-e 's|EMAIL@ADDRESS|mike.ray@btinternet.com|' \
-e 's|PACKAGE VERSION|0.1.0alpha|' \
-e 's|FULL NAME|Mike Ray|' \
> rpi-image-tool.pot


