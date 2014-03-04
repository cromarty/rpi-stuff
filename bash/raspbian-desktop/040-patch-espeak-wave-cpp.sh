#!/bin/bash

WAVE_CPP=$(ls espeak*/src/wave.cpp)
sed -i -e 's:#define FRAMES_PER_BUFFER 512:#define FRAMES_PER_BUFFER 2048:' \
   -e 's:paFramesPerBufferUnspecified:FRAMES_PER_BUFFER:' \
   -e 's:(double)0.1:(double)0.2:' \
   -e 's:double aLatency = deviceInfo->defaultLowOutputLatency:double aLatency = deviceInfo->defaultHighOutputLatency:' "${WAVE_CPP}"

exit 0
