#!/bin/bash

set -e

. ./common-code

[ -f script.result ] && truncate -s 0 script.result

echo "Starting $0..." | tee -a script.result

# kill the horrible un-accessible whiptail raspi-config process and remove the script
PID=$(pgrep raspi-config)
[ ${PID} ] && kill -9 ${PID} ; rm /etc/profile.d/raspi-config

echo "$0 Completed successfully" | tee -a script.result
exit 0

