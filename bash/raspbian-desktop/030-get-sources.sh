 #!/bin/bash

#git clone git://git.debian.org/git/pkg-a11y/espeak.git
#git clone git://git.debian.org/pkg-a11y/speech-dispatcher.git

apt-get source espeak
apt-get source speech-dispatcher
apt-get source speechd-up

rm espeak*.tar.gz
rm espeak*.dsc

rm speech-dispatcher*.tar.gz
rm speech-dispatcher*.dsc

rm speechd-up*.tar.gz
rm speechd-up*.dsc

exit 0
