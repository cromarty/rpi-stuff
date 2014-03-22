#!/bin/bash

for name in *.sh
do
sed -i-old 's:echo.*result::g' ${name}
done


