#!/bin/bash
#
# Converts all the .m4a files in a directory into .mp3 format
#
# Needs faad2 and lame installed
#
# Does not remove the .m4a files after conversion
#

for M4A in *.m4a; do
 MP3=${M4A%.m4a}.mp3
	echo "Converting: ${M4A}"
	faad -q -o - "${M4A}" | lame - "${MP3}"
done

echo done

