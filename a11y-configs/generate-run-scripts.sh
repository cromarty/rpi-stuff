#!/bin/bash

make_script() {
	cat <<eof > "${1}.run.sh"
#!/bin/bash

_run() {

pushd "\${SCRIPT_PATH}" >/dev/null
for SCR in *.sh
do
./\${SCR}
done

}

set -e
export BUILD_PATH=~/.builds
export CONFIG_PATH=$(pwd)/config
export SCRIPT_PATH=$(pwd)/scripts
export UTILS_PATH=$(pwd)/utils
export SM_LOG_FILE=\${BUILD_PATH}/\${1}.log

_run | tee "\${SM_LOG_FILE}"

exit 0

eof

}

for DISTRO in */
do
pushd "${DISTRO}" >/dev/null
for S_PACK in */
do
pushd "${S_PACK}" >/dev/null
SCRIPT=$(echo "${S_PACK}" | sed 's:/::')
make_script "${SCRIPT}"
touch "${SCRIPT}.sh"
popd >/dev/null
done
popd >/dev/null
done