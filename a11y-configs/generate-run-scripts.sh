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
export SM_PACKAGE_PATH="\${BUILD_PATH}/packages"
export PACKAGE_URL=aurora/packages
export CONFIG_PATH=$(pwd)/config
export SCRIPT_PATH=$(pwd)/scripts
export UTILS_PATH=$(pwd)/utils
export SM_LOG_FILE=\${BUILD_PATH}/\${1}.log
export SM_TIDY=yes

mkdir -p "\${BUILD_PATH}"
mkdir -p "\${SM_PACKAGE_PATH}"

_run | tee "\${SM_LOG_FILE}"

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
