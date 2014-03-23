#!/bin/bash

set -e
cd "${BUILD_PATH}"

echo "-- A script which deliberately returns a non-zero exit code"
exit 1
