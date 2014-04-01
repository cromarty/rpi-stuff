#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Adding 'export DTK_PROGRAM=espeak' to /etc/skel.bashrc...'
cat <<eof >> /etc/skel/.bashrc

export DTK_PROGRAM=espeak

# reload speakup settings if the local directory exists
if [ -d ~/.speakup ]; then
	speakupconf load
fi

eof

echo '-- Finished adding DTK_PROGRAM=espeak to /etc/skel/.bashrc'
exit 0



