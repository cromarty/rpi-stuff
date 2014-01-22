#!/bin/bash
# Test the speed of our internet connection.
# Results displayed in megabits/second

echo "Testing speed of internet connection..."

SPEED=$(iperf -f m -c iperf.scottlinux.com | grep 'Mbits' | sed -r 's:.*Bytes\s+([0-9]+\.[0-9]+)\s+Mbits/sec:\1:')
echo "${SPEED} Megabits per second"






 

