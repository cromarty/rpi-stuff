#!/bin/bash

set -e

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result

install -t "${UTILS_PATH}/test.txt" ~/

echo "$0 Completed successfully" | tee -a script.result
exit 0
