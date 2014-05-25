#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo '-- Building espeakup...'
git clone https://github.com/williamh/espeakup.git
pushd espeakup > /dev/null
make
make install
popd > /dev/null
echo '-- Finished building and installing espeakup, tidying up...'
if [ "${TIDY}" ]; then
	set +e
	rm -rf espeakup
fi
exit 0



