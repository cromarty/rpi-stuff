#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Adding speakupconf and DTK_PROGRAM stuff to .bashrc..."
cat <<eof > /etc/skel/.bashrc

if [ -d ~/.speakup ]; then
	speakupconf load
fi

export DTK_PROGRAM=espeak

eof

echo "-- Finished adding speakup and Emacspeak stuff to /etc/skel/.bashrc"
exit 0



