#!/bin/bash

FANFARE=/usr/share/sounds/sound-icons/trumpet-12.wav

set -e
echo '-- Finalizing the LXDE installation...'
[ -f "${FANFARE}" ] && aplay "${FANFARE}"
exit 0
