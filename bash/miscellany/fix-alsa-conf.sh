#!/bin/bash
#
# This script comments out the cards from /usr/share/alsa/alsa.conf which don't exist.
# These entries are responsible for loads of errors when using text-to-speech
#

# check we're root
if [ $(id -u) -ne 0 ]; then
    echo "Script must be run as root. Try 'sudo ./fix-alsa-conf.sh'"
    exit 1
    fi

ALSA_CONF=/usr/share/alsa/alsa.conf

if [ ! -f ${ALSA_CONF} ]; then
    echo "Couldn't find the file ${ALSA_CONF}, script will exit."
        exit 1
fi
   

echo "Fixing ${ALSA_CONF} to comment out bad cards..."

# save a temporary copy of the config file
 cp ${ALSA_CONF} ${ALSA_CONF}.original

# write a perl script on the fly
cat <<\EOF > ~/fix-alsa-conf.pl 
#!/usr/bin/perl -w
#
# Reads the alsa.conf file of a Raspbian or Arch install and comments
# out the lines necessary to get rid of all the PCM error messages
# which are produced each time the Pi is made to make a sound.
#  Notes: 
#  Might also disable HDMI output.  I have no way to test whether this is true.
#  If HDMI is disabled, uncomment the line which contains 'HDMI which was commented out by this script
#
# Usage: sudo cat /usr/share/alsa/alsa.conf | ./fix-alsa-conf.pl > /usr/share/alsa/alsa.conf
#
# Contains no paranoia checking.
# Provided free in the hope it is of use.  No guarantee of
# fitness of purpose is given.  Use at own risk.  No liability for loss of data or functionality is given
# or implied.
#
# April 2013.  Mike Ray <mike.ray@btinternet.com>
#

while(<>) {
	s/^(pcm\.front cards\.pcm\.front)/#$1/;
	s/^(pcm\.rear cards\.pcm\.rear)/#$1/;
	s/^(pcm\.center_lfe cards\.pcm\.center_lfe)/#$1/;
	s/^(pcm\.side cards\.pcm\.side)/#$1/;
	s/^(pcm\.surround40 cards\.pcm\.surround40)/#$1/;
	s/^(pcm\.surround41 cards\.pcm\.surround41)/#$1/;
	s/^(pcm\.surround50 cards\.pcm\.surround50)/#$1/;
	s/^(pcm\.surround51 cards\.pcm\.surround51)/#$1/;
	s/^(pcm\.surround71 cards\.pcm\.surround71)/#$1/;
	s/^(pcm\.iec958 cards\.pcm\.iec958)/#$1/;
	s/^(pcm\.spdif iec958)/#$1/;
	s/^(pcm\.hdmi cards\.pcm\.hdmi)/#$1/;
	s/^(pcm\.dmix cards\.pcm\.dmix)/#$1/;
	s/^(pcm\.modem cards\.pcm\.modem)/#$1/;
	s/^(pcm\.phoneline cards\.pcm\.phoneline)/#$1/;
	print;
}

EOF

chmod +x ~/fix-alsa-conf.pl

cat ${ALSA_CONF}.original | ~/fix-alsa-conf.pl > ${ALSA_CONF}

chmod 644 ${ALSA_CONF}

rm ~/fix-alsa-conf.pl


echo "Done"

