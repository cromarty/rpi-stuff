#!/bin/bash

set -e
cd ${BUILD_PATH}
echo '-- Updating Raspbian...'
apt-get update
echo '-- Finished updating Raspbian'
exit 0
