#!/bin/bash
MF=$(ls espeak*/src/Makefile)


sed -i -e 's:DATADIR=/usr/share/espeak-data:DATADIR=/usr/lib/arm-linux-gnueabihf/espeak-data:' \
     -e 's:LIBDIR=\$(PREFIX)/lib:LIBDIR=\${PREFIX}/lib/arm-linux-gnueabihf:' \
     -e 's:\$(CXX) \$(LDFLAGS):\$(CXX) -L/usr/lib/arm-linux-gnueabihf \$(LDFLAGS):' "${MF}"

exit 0


