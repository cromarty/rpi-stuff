#!/bin/bash

# Must be run with sudo -E

. ./common-code

CFGPATH="${BUILD_PATH}/config"
USER_NAME=speech-dispatcher
USER_GROUP=audio
HOME_DIR=/var/log/speech-dispatcher

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result
echo "-- Setting up configuration stuff for speech-dispatcher and speechd-up..."

# /etc stuff
mkdir /etc/speech-dispatcher &&
cp -prf /usr/share/speech-dispatcher/conf/* /etc/speech-dispatcher &&
install -m 644 ${CFGPATH}/speechd.conf /etc/speech-dispatcher &&
 install -m 755 ${CFGPATH}/init.d/speech-dispatcher /etc/init.d &&
 install -m 755 ${CFGPATH}/init.d/speechd-up /etc/init.d &&
 install -m 644 ${CFGPATH}/default/speech-dispatcher /etc/default &&
 install -m 644 ${CFGPATH}/default/speechd-up /etc/default &&
install -m 644 ${CFGPATH}/speechd-up.conf /etc/speechd-up.conf
check_errs $? "Failed writing configuration and init files to /etc"

# local config
mkdir -p ~/.speech-dispatcher/conf &&
cp -prf /usr/share/speech-dispatcher/conf/* ~/.speech-dispatcher/conf &&
install -m 644 ${CFGPATH}/speechd.conf ~/.speech-dispatcher/conf/speechd.conf &&
 chown -R pi:pi ~/.speech-dispatcher/ &&
 mkdir ~/.pulse &&
 install -m 644 ${CFGPATH}/pulse/default.pa ~/.pulse/default.pa
  check_errs $? "Failed installing configurations to ~/.speech-dispatcher"

# create speech-dispatcher user and home directory
# this code is taken from the Debian package for speech-dispatcher 
echo "-- Creating the speech-dispatcher user and it's home directory..."
if ! id -u $USER_NAME >/dev/null 2>&1; then
	adduser --quiet --system --ingroup $USER_GROUP \
		--home $HOME_DIR \
		--shell /bin/sh --disabled-login  \
		--gecos 'Speech Dispatcher' $USER_NAME
	chown -R $USER_NAME:$USER_GROUP $HOME_DIR
elif ! test -d $HOME_DIR; then
	if test -d /var/run/speechd; then
		mv /var/run/speechd $HOME_DIR
	else
		mkdir $HOME_DIR
	fi
fi

chown -R $USER_NAME:$USER_GROUP ${HOME_DIR}
chmod 0775 ${HOME_DIR}

echo "$0 Completed successfully" | tee -a script.result
exit 0
