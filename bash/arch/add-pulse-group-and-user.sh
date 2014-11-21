#!/bin/bash

pulse_user_and_group_stuff() {
	echo "-- Adding groups pulse and pulse-access, and adding user pulse..."
	if [ -z $(cat /etc/group | grep '^[p]ulse:' | cut -f 1 -d:) ]; then
		groupadd -g 58 pulse
	else
		echo "-- Group pulse already exists"
	fi
	if [ -z $(cat /etc/group | grep '^[p]ulse-access:' | cut -f 1 -d:) ]; then
		groupadd -g 59 pulse-access
	else
		echo "-- Group pulse-access already exists"
	fi
	if [ -z $(cat /etc/passwd | grep '^[u]ser:' | cut -f 1 -d:) ]; then
		useradd -c "Pulseaudio User" -d /var/run/pulse -g pulse -G pulse-access -s /bin/false -u 58 pulse
	else
		echo "-- User pulse already exists"
	fi
} # pulse_user_and_group_stuff


pulse_user_and_group_stuff


