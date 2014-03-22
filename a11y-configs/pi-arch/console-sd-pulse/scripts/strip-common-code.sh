#!/bin/bash

for name in *.sh
do
sed -i-old 's:\. \./common-code::g' ${name}
done


