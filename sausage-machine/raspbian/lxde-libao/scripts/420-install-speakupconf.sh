#!/bin/bash
set -e

cd "${BUILD_PATH}"
install -m 755 -t /usr/bin "${UTILS_PATH}"/speakupconf
exit 0

