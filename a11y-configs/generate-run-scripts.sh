#!/bin/bash

make_script() {
	cat <<eof > "${1}.run.sh"
#!/bin/bash

_run() {

	pushd "\${SCRIPT_PATH}" >/dev/null
	[ -f run.list ] || cp script.list run.list
	cat run.list | \
	while read  SCR
	do
		./\${SCR}
		sed -i '1d' run.list
	done

}

set -e
export BUILD_PATH=~/.builds
export PACKAGE_PATH="\${BUILD_PATH}/packages"
export PACKAGE_URL=aurora/packages
export CONFIG_PATH=$(pwd)/config
export RELEASE_PATH=$(pwd)/release
export SCRIPT_PATH=$(pwd)/scripts
export UTILS_PATH=$(pwd)/utils
export LOG_NAME=\$(basename \$0 | cut -f 1 -d. ).log
export LOG_FILE=\${BUILD_PATH}/\${LOG_NAME}

mkdir -p "\${PACKAGE_PATH}"

date | tee "\${LOG_FILE}"
echo "Build path: \${BUILD_PATH}" | tee -a "\${LOG_FILE}"
echo "Config path: \${CONFIG_PATH}" | tee -a "\${LOG_FILE}"
echo "Release path: \${RELEASE_PATH}" | tee -a "\${LOG_FILE}"
echo "Script path: \${SCRIPT_PATH}" | tee -a "\${LOG_FILE}"
echo "Utils path: \${UTILS_PATH}" | tee -a "\${LOG_FILE}"

_run | tee -a "\${LOG_FILE}"

echo "-- \$0 finished" | tee -a "\${LOG_FILE}"

date | tee -a "\${LOG_FILE}"

exit 0

eof

chmod +x "${1}.run.sh"

}

for DISTRO in */
do
	echo "Processing distro: ${DISTRO}..."
	pushd "${DISTRO}" >/dev/null
	for S_PACK in */
	do
			pushd "${S_PACK}" >/dev/null
		echo "Generating run script for: ${S_PACK}..."
		SCRIPT=$(echo "${S_PACK}" | sed 's:/::')
		make_script "${SCRIPT}"
		pushd scripts >/dev/null
		ls -1 *.sh > script.list
		popd >/dev/null
		popd >/dev/null
	done
	popd >/dev/null
done

exit 0
