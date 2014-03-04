#!/bin/bash

check_errs() {
	# used for checking return value of function calls
	if [ "${1}" -ne "0" ]; then
		echo "-- Error ${1} : ${2}" | tee -a script.result
		exit ${1}
	fi
} # check_errs


init-d-speech-dispatcher() {
	cat <<eof > /etc/init.d/speech-dispatcher
#! /bin/sh

### BEGIN INIT INFO
# Provides:          speech-dispatcher
# Required-Start:    \$remote_fs \$syslog
# Required-Stop:     \$remote_fs \$syslog
# Should-Start:      festival
# Should-Stop:       festival
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Speech Dispatcher
# Description:       Common interface to speech synthesizers
### END INIT INFO

PATH=/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/bin/speech-dispatcher
PIDFILE=/var/run/speech-dispatcher/speech-dispatcher.pid
NAME=speech-dispatcher
DESC='Speech Dispatcher'
USER=speech-dispatcher

test -f \$DAEMON || exit 0

. /lib/lsb/init-functions

RUN=no

# Include speech-dispatcher defaults if available
if [ -f /etc/default/speech-dispatcher ] ; then
    . /etc/default/speech-dispatcher
fi

if [ "x\$RUN" != "xyes" ] ; then
    echo "\$NAME disabled; edit /etc/default/speech-dispatcher"
    exit 0
fi

set -e

do_start () {
  PIDDIR=`dirname \$PIDFILE`
  [ -e \$PIDDIR ] || install -d -ospeech-dispatcher -gaudio -m750 \$PIDDIR
  SDDIR=\$PIDDIR/.speech-dispatcher
  [ -e \$SDDIR ] || ln -s \$PIDDIR \$SDDIR
  LOGDIR=\$SDDIR/log
  [ -e \$LOGDIR ] || ln -s /var/log/speech-dispatcher \$LOGDIR
  start-stop-daemon --oknodo --start --quiet --chuid \$USER --pidfile \$PIDFILE \
    --exec \$DAEMON -- --pid-file \$PIDFILE
}

do_stop () {
  start-stop-daemon --oknodo --stop --quiet --user \$USER \
    --pidfile \$PIDFILE --exec \$DAEMON
}

case "\$1" in
  start)
	log_daemon_msg "Starting \$DESC" "speech-dispatcher"
        do_start
	log_end_msg \$?
	;;
  stop)
	log_daemon_msg "Stopping \$DESC" "speech-dispatcher"
        do_stop
	log_end_msg \$?
	;;
  reload|force-reload)
	log_daemon_msg "Reloading \$DESC configuration files" "speech-dispatcher"
	start-stop-daemon --oknodo --stop --signal 1 --quiet --user \$USER \
          --pidfile \$PIDFILE --exec \$DAEMON
        log_end_msg \$?
        ;;
  restart)
	log_daemon_msg "Restarting \$DESC" "speech-dispatcher"
        do_stop
	sleep 3
        do_start
	log_end_msg \$?
	;;
  *)
	N=/etc/init.d/\$NAME
	echo "Usage: \$N {start|stop|restart|reload|force-reload}" >&2
	exit 1
	;;
esac

exit 0

eof

} # init-d-speech-dispatcher


default-speech-dispatcher() {
	cat <<eof > /etc/default/speech-dispatcher
# Defaults for the speech-dispatcher initscript, from speech-dispatcher

# Set to yes to start system wide Speech Dispatcher
RUN=no

eof

} # default-speech-dispatcher


BUILD_PATH=$(ls -d speech-dispatcher-*)

if [ $(id -u) -ne 0 ]; then
	echo "-- Script must be run as root. Try 'sudo $0'"
	exit 1
fi

cd "${BUILD_PATH}"

./configure \
  --prefix=/usr \
  --libdir=/usr/lib/arm-linux-gnueabihf \
  --enable-shared \
  --disable-static \
  --without-flite \
  --without-ibmtts \
  --with-espeak \
  --without-ivona \
  --without-nas \
  --without-oss \
  --without-libao \
  --with-alsa \
  --with-pulse

check_errs $? "Failed in configure"

make all
check_errs $? "Failed in make all"

make install
check_errs $? "Failed in make install"

# need to copy some config stuff
mkdir -m 0755 -p /etc/speech-dispatcher &&
cp -r /usr/share/speech-dispatcher/conf/* /etc/speech-dispatcher/
check_errs $? "Failed setting up speech-dispatcher stuff in /etc"

# set up /etc/default/speech-dispatcher
default-speech-dispatcher
chmod 0644 /etc/default/speech-dispatcher

# set up /etc/init.d/speech-dispatcher
init-speech-dispatcher
chmod 0755 /etc/init.d/speech-dispatcher

echo "$0 Completed successfully" | tee -a script.result
exit 0
