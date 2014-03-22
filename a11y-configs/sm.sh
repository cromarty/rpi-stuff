#!/bin/bash



EXPORT_FLAG=
BUILD_PATH_FLAG=
BUILD_PATH="$BUILD_PATH"
CONFIG_PATH_FLAG=
CONFIG_PATH="$CONFIG_PATH"
UTILS_PATH_FLAG=
UTILS_PATH="$UTILS_PATH"



usage() {
	printf "Usage: %s [OPTIONS...]\n" $(basename $0)
	printf "\t -h %s\n" "Show this help text and exit"
	printf "\t -e %s\n" "Prepend 'export ' to each variable-name line"
	printf "\t -b <build path>\n"
	printf "\t -c <config path>\n"
	printf "\t -u <utils path>\n\n"
	printf "\tIf the -e switch is given, just print each variable 
to standard output and exit\n"
}

while getopts 'ehb:c:u:' OPTION
do
	case $OPTION in
		e)
			EXPORT_FLAG=1
		;;
		h)
			usage > /dev/stderr
			exit 0
		;;
		b)
			BUILD_PATH_FLAG=1
			BUILD_PATH="$OPTARG"
		;;
		c)
			CONFIG_PATH_FLAG=1
			CONFIG_PATH="$OPTARG"
		;;
		u)
			UTILS_PATH_FLAG=1
			UTILS_PATH="$OPTARG"
		;;
		?)
			usage
			exit 0
		;;
	esac
done

shift $(($OPTIND - 1))

if [ "$EXPORT_FLAG" ]; then
	echo "export BUILD_PATH=$BUILD_PATH"
	echo "export CONFIG_PATH=$CONFIG_PATH"
	echo "export UTILS_PATH=$UTILS_PATH"
	exit 0
else
	[ "$BUILD_PATH" ] || { echo "BUILD_PATH is not set" ; exit 1 ; }
[ "$CONFIG_PATH" ] || { echo "CONFIG_PATH is not set" ; exit 1 ; }
[ "$UTILS_PATH" ] || { echo "UTILS_PATH is not set" ; exit 1 ; }
fi
export BUILD_PATH="$BUILD_PATH"
export CONFIG_PATH="$CONFIG_PATH"
export UTILS_PATH="$UTILS_PATH"

echo "$BUILD_PATH"
echo "$CONFIG_PATH"
echo "$UTILS_PATH"


[ "$1" ] &&  cd "$1"

LOG_FILE=~/sausage-machine.log

echo "Starting the sausage-machine..." | tee "${LOG_FILE}"

set -e
shopt -s extglob

for SCRIPT_NAME in +([0-9])*.sh
do
	echo "Starting ${SCRIPT_NAME}" | tee -a "${LOG_FILE}"
	./${SCRIPT_NAME}
	if [ $? -gt 0 ]; then
		echo "${SCRIPT_NAME} returned non-zero code, aborting" | tee -a "${LOG_FILE}"
		exit 1
	fi
	echo "${SCRIPT_NAME} completed successfully" | tee -a "${LOG_FILE}"
done

