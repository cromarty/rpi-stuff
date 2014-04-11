#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Adding speakupconf and DTK_PROGRAM stuff to .bashrc..."
cat <<eof >> /etc/skel/.bashrc

if [ -d ~/.speakup ]; then
	speakupconf load >/dev/null
fi

export DTK_PROGRAM=espeak

# clear bash history on login
> ~/.bash_history && history -c

eof
echo '-- Adding some stuff to .bash_logout...'
cat <<eof >> /etc/skel/.bash_logout

# clear the bash history on logout
> ~/.bash_history && history -c

eof

echo "-- Finished adding speakup and Emacspeak stuff to /etc/skel/.bashrc"
exit 0



