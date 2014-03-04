#!/bin/bash

./010-prep.sh
./020-libs.sh
./030-get-sources.sh
./040-patch-espeak-wave-cpp.sh
./050-patch-espeak-makefile.sh
./060-build-espeak.sh
./070-build-speech-dispatcher.sh
./075-install-speechd-up.sh
./080-dummy-espeak.sh
./090-dummy-speech-dispatcher.sh

exit 0
