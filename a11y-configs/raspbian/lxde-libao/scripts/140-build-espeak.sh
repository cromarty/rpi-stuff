#!/bin/bash


set -e
cd "${BUILD_PATH}"
## get the source
echo '-- Getting the espeak source from sourceforge...'
wget http://sourceforge.net/projects/espeak/files/espeak/espeak-1.48/espeak-1.48.02-source.zip
unzip espeak-1.48.02-source.zip
## patch
echo "-- Patching espeak source code with latency tweaks and patching Makefile..."
WAVE_CPP=$(ls espeak*/src/wave.cpp)
sed -i -e 's:#define FRAMES_PER_BUFFER 512:#define FRAMES_PER_BUFFER 2048:' \
   -e 's:paFramesPerBufferUnspecified:FRAMES_PER_BUFFER:' \
   -e 's:(double)0.1:(double)0.2:' \
   -e 's:double aLatency = deviceInfo->defaultLowOutputLatency:double aLatency = deviceInfo->defaultHighOutputLatency:' "${WAVE_CPP}"

MF=$(ls espeak*/src/Makefile)
sed -i -e 's:DATADIR=/usr/share/espeak-data:DATADIR=/usr/lib/arm-linux-gnueabihf/espeak-data:' \
	-e 's:LIBDIR=\$(PREFIX)/lib:LIBDIR=\${PREFIX}/lib/arm-linux-gnueabihf:' \
	-e 's:\$(CXX) \$(LDFLAGS):\$(CXX) -L/usr/lib/arm-linux-gnueabihf \$(LDFLAGS):' "${MF}"

## build
echo "-- Building espeak..."
pushd $(ls -d espeak-*/src)
cp portaudio19.h portaudio.h
make all
make install
install -m 755 speak /usr/bin
echo '-- Finished building espeak'
exit 0



