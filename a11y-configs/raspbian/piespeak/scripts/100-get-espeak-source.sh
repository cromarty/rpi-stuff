#!/bin/bash

set -e
cd ${BUILD_PATH}
echo '-- Getting espeak source...'
wget http://sourceforge.net/projects/espeak/files/espeak/espeak-1.48/espeak-1.48.02-source.zip
unzip espeak-1.48.02-source.zip
pushd espeak-1.48.02 >/dev/null
popd >/dev/null
echo '-- Finished getting espeak source'
exit 0


