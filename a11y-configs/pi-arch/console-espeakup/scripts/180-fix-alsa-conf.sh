#!/bin/bash

set -e
cd "${BUILD_PATH}"
echo "-- Fixing /usr/share/alsa/alsa.conf to comment out cards which do not exist..."
sed -i-old -e 's:^\(pcm\.front cards\.pcm\.front\):#\1:' \
	-e 's:^\(pcm\.rear cards\.pcm\.rear\):#\1:' \
	-e 's:^\(pcm\.center_lfe cards\.pcm\.center_lfe\):#\1:' \
	-e 's:^\(pcm\.side cards\.pcm\.side\):#\1:' \
	-e 's:^\(pcm\.surround40 cards\.pcm\.surround40\):#\1:' \
	-e 's:^\(pcm\.surround41 cards\.pcm\.surround41\):#\1:' \
	-e 's:^\(pcm\.surround50 cards\.pcm\.surround50\):#\1:' \
	-e 's:^\(pcm\.surround51 cards\.pcm\.surround51\):#\1:' \
	-e 's:^\(pcm\.surround71 cards\.pcm\.surround71\):#\1:' \
	-e 's:^\(pcm\.iec958 cards\.pcm\.iec958\):#\1:' \
	-e 's:^\(pcm\.spdif iec958\):#\1:' \
	-e 's:^\(pcm\.hdmi cards\.pcm\.hdmi\):#\1:' \
	-e 's:^\(pcm\.dmix cards\.pcm\.dmix\):#\1:' \
	-e 's:^\(pcm\.modem cards\.pcm\.modem\):#\1:' \
	-e 's:^\(pcm\.phoneline cards\.pcm\.phoneline\):#\1:' /usr/share/alsa/alsa.conf

echo "-- Old alsa.conf file saved to /usr/share/alsa/alsa.conf-old"
echo "-- Deleting pulse stuff from /usr/share/alsa/* if any exists..."
set +e
rm -rf /usr/share/alsa/alsa.conf.d
exit 0
