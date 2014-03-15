#!/bin/bash

. ./common-code

cd "${BUILD_PATH}"

echo "Starting $0..." | tee -a script.result
echo "-- Patching espeak source code with latency tweaks and patching Makefile..."

#WAVE_CPP=$(ls espeak*/src/wave.cpp)
#
#sed -i -e 's:#define FRAMES_PER_BUFFER 512:#define FRAMES_PER_BUFFER 2048:' \
#   -e 's:paFramesPerBufferUnspecified:FRAMES_PER_BUFFER:' \
#   -e 's:(double)0.1:(double)0.2:' \
   #-e 's:double aLatency = deviceInfo->defaultLowOutputLatency:double aLatency = deviceInfo->defaultHighOutputLatency:' "${WAVE_CPP}"

MF=$(ls espeak*/src/Makefile)

sed -i -e 's:DATADIR=/usr/share/espeak-data:DATADIR=/usr/lib/arm-linux-gnueabihf/espeak-data:' \
     -e 's:LIBDIR=\$(PREFIX)/lib:LIBDIR=\${PREFIX}/lib/arm-linux-gnueabihf:' \
     -e 's:\$(CXX) \$(LDFLAGS):\$(CXX) -L/usr/lib/arm-linux-gnueabihf \$(LDFLAGS):' \
     -e 's:AUDIO = portaudio:#AUDIO = portaudio:' \
     -e 's:#AUDIO = pulseaudio:AUDIO = pulseaudio:' "${MF}"

echo "$0 Completed successfully" | tee -a script.result
exit 0
