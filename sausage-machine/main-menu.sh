#!/bin/bash
raspbian-lxde-alsa() {
	echo 'In raspbian-lxde-alsa'
} # raspbian-lxde-alsa

raspbian-lxde-pulse() {
	echo 'In raspbian-lxde-pulse'
} # raspbian-lxde-pulse


main_menu() {
	MENUCHOICE="Raspbian-lxde-alsa Raspbian-lxde-pulse Exit"

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
						raspbian-lxde-alsa
					;;
					2)
						raspbian-lxde-pulse
					;;
				esac
				break
			else
				echo "Invalid selection!"
			fi # end of handle user's selection
		done # end of select a directory
	done # end of while not finished
}

main_menu
