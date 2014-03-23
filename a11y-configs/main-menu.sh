#!/bin/bash

sausage_machine() {
	CONFIG_PATH="${SAUSAGE_PACK}/config"
	SCRIPT_PATH="${SAUSAGE_PACK}/scripts"
	UTILS_PATH="${SAUSAGE_PACK}/utils"

	../sausage-machine/sm.sh \
		-b "${BUILD_PATH}" \
		-c "${CONFIG_PATH}" \
		-u "${UTILS_PATH}" \
		"${SCRIPT_PATH}" | tee sausage-machine.log

exit 0
} # sausage_machine

raspbian_lxde_alsa() {
	SAUSAGE_PACK="${SAUSAGE_PACK_ROOT}/raspbian/lxde-alsa"
	sausage_machine
} # raspbian_lxde_alsa

raspbian_lxde_pulse() {
	SAUSAGE_PACK="${SAUSAGE_PACK_ROOT}/raspbian/lxde-pulse"
	sausage_machine
} # raspbian_lxde_pulse

raspbian_lxde_libao() {
	SAUSAGE_PACK="${SAUSAGE_PACK_ROOT}/raspbian/lxde-libao"
	sausage_machine
} # raspbian_lxde_libao

test_pack() {
	SAUSAGE_PACK="${SAUSAGE_PACK_ROOT}/test-pack"
	sausage_machine
} # test_pack



main_menu() {
	MENUCHOICE="Raspbian-lxde-alsa Raspbian-lxde-pulse Raspbian-lxde-libao test-pack Exit"

	# Set a useful select prompt
	PS3='Selection? '
	until [ "$selection" == "Exit" ]
	do
		printf "%b" "\a\n\nSelect a Sausage-pack to process:\n" >&2
		select selection in $MENUCHOICE
		do
			# User types a number which is stored in $REPLY, but select
			# returns the value of the entry
			if [ "$selection" = "Finished" ]; then
				echo "Exit from main menu."
				break
			elif [ -n "$selection" ]; then
				echo "You chose number $REPLY, processing $selection ..."
				# Do something here
				case "$REPLY" in
					1)
						raspbian_lxde_alsa
					;;
					2)
						raspbian_lxde_pulse
					;;
					3)
						raspbian_lxde_libao
					;;
4)
test_pack
;;
				esac
				break
			else
				echo "Invalid selection!"
			fi # end of handle user's selection
		done # end of select a directory
	done # end of while not finished
}
BUILD_PATH=~/.builds
SAUSAGE_PACK_ROOT=$( cd $(dirname $0) ; pwd -P )
cd "${SAUSAGE_PACK_ROOT}"

main_menu
