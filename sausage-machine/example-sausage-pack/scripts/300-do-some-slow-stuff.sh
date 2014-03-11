#!/bin/bash

set -e

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result

echo "Do some slow stuff..." | tee -a script.result
sleep 2s
echo "Do some more slow stuff..." | tee -a script.result
sleep 3s
echo "Do yet more very slow stuff..." | tee -a script.result
sleep 10s

echo "$0 Completed successfully" | tee -a script.result
exit 0
