#!/bin/bash

set -e
cd ${BUILD_PATH}
echo '-- Installing a bunch of needed packages, a lengthy process...'
pacman -S --noconfirm --noprogressbar --needed base-devel unzip parted git portaudio alsa-utils bc gnutls fuse sshfs tcl tk emacs-nox yajl icu libao
echo '-- Finished installing packages'
exit 0

