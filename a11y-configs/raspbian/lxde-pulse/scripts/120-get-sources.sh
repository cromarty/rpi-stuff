 #!/bin/bash

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result
echo "-- Getting source code for espeak, speech-dispatcher and speechd-up..."

apt-get source espeak &&
apt-get source speech-dispatcher
check_errs $? "Failed to get sources for espeak and speech-dispatcher"

wget http://devel.freebsoft.org/pub/projects/speechd-up/speechd-up-0.4.tar.gz &&
tar -xzvf speechd-up-0.4.tar.gz
check_errs $? "Failed to remove speechd-up*.tar"

echo "$0 Completed successfully" | tee -a script.result
exit 0
