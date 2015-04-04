#!/bin/bash
# convert ogg to mp3

set -e

for OGG in *.ogg
do
	MP3=${OGG%.ogg}.mp3
	ffmpeg -i "${OGG}" "${MP3}"
done

echo done

