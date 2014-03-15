#!/bin/bash

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result

wget http://devel.freebsoft.org/pub/projects/sound-icons/sound-icons-0.1.tar.gz
check_errs $? "Failed to get sound icons pack"

mkdir -p -m 755 /usr/share/sounds/sound-icons &&
tar -xzf ${BUILD_PATH}/sound-icons-0.1.tar.gz &&
install -t /usr/share/sounds/sound-icons sound-icons-0.1/*
check_errs $? "Failed to unpack sound icons"

echo "$0 Completed successfully" | tee -a script.result
exit 0



