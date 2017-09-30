#!/bin/bash
#
# Info taken from:
#
# https://www.raspberrypi-spy.co.uk/2012/09/checking-your-raspberry-pi-board-version/
#

pi_revision=$(cat /proc/cpuinfo | grep 'Revision' | sed 's|Revision\s\+:\s\+\(.*\)|\1|')

case "${pi_revision}" in
	'0002')
		echo 'Model B Rev 1:256MB'
	;;
	'0003')
		echo 'Model B Rev 1 ECN0001 (no fuses, D14 removed):256MB'
	;;
	'0004'|'0005'|'0006')
		echo 'Model B Rev 2:256MB'
	;;
	'0007'|'0008'|'0009')
		echo 'Model A:256MB'
	;;
	'000d'|'000e'|'000f')
		echo 'Model B Rev 2:512MB'
	;;
	'0010'|'0013'|'900032')
		echo 'Model B+:512MB'
	;;
	'0011'|'0014'*)
		echo 'Compute Module:512MB'
	;;
	'0012'|'0015'*)
		echo 'Model A+:256MB'
	;;
	'0015'*)
		echo 'Model A+:512MB'
	;;
	'a01041'*|'a21041'*)
		echo 'Pi 2 Model B v1.1:1GB'
	;;
	'a22042')
		echo 'Pi 2 Model B v1.2:1GB'
	;;
	'900092')
		echo 'Pi Zero v1.2:512MB'
	;;
	'900093')
		echo 'Pi Zero v1.3:512MB'
	;;
	'9000C1')
		echo 'Pi Zero W:512MB'
	;;
	'a02082'*)
		echo 'Pi 3 Model B:1GB'
	;;
	'a22082'*)
		echo 'Pi 3 Model B:1GB'
	;;
	*)
		echo 'Unidentified'
	;;
esac

