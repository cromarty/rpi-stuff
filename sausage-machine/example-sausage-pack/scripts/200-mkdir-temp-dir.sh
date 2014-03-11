#!/bin/bash

set -e

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result

mkdir -p temp/docs

echo "$0 Completed successfully" | tee -a script.result
exit 0



echo "$0 Completed successfully" | tee -a script.result
exit 0
