#!/bin/bash

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result
echo "-- Inserting speakup_soft into /etc/modules..."

echo "speakup_soft" >> /etc/modules
check_errs $? "Failed adding speakup_soft to /etc/modules"

echo "$0 Completed successfully" | tee -a script.result
exit 0
