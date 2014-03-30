#!/bin/bash

set -e

cd "${BUILD_PATH}"
echo "-- A script which will deliberately fail with a non-zero exit code"
which this-is-something-which-does-not-exist &> /dev/null
exit 0

