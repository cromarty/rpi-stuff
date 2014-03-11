#!/bin/bash

set -e

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result

# simulate script failure by returning non-zero
exit 1

echo "$0 Completed successfully" | tee -a script.result

exit 0 # (we already went above)
