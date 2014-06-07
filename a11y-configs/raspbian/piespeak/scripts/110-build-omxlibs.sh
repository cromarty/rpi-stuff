#!/bin/bash

set -e
echo '-- Building the OpenMAX ILClient libs...'
cd /opt/vc/src/hello_pi
make -C libs/ilclient
make -C libs/vgfont
echo '-- Finished making the OpenMAX ILClient libs'
exit 0




