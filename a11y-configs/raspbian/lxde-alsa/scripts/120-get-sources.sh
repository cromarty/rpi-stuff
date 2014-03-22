 #!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Getting source code for espeak, speech-dispatcher and speechd-up..."
#apt-get source espeak
wget http://sourceforge.net/projects/espeak/files/espeak/espeak-1.48/espeak-1.48.02-source.zip
unzip espeak-1.48.02-source.zip
apt-get -y -q source speech-dispatcher
wget http://devel.freebsoft.org/pub/projects/speechd-up/speechd-up-0.4.tar.gz
tar -xzvf speechd-up-0.4.tar.gz
exit 0
