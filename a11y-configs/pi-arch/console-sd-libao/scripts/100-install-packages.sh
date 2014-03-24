#!/bin/bash

set -e
cd ${BUILD_PATH}
echo "-- Installing a bunch of needed packages..."
pacman -S --noconfirm --noprogressbar --needed base-devel unzip parted git portaudio alsa-utils bc gnutls fuse sshfs tcl tk emacs-nox
exit 0

