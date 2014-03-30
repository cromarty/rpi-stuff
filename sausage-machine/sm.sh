#!/bin/bash

sausages() {

	for SCRIPT in ../a11y-configs/raspbian/lxde-libao/scripts/*.sh
	do
		if [ -f ${SCRIPT} -a -f ${SCRIPT} ]; then
			#${SCRIPT}
echo "${SCRIPT}"
		fi
	done
 
}

set -e

./.sm.pl
if [ $? -gt 0 ]; then
echo "failed"
exit 1
fi
. ./exports~
mkdir -p "${BUILD_PATH}"
sausages | tee "${SM_LOG_FILE}" 


