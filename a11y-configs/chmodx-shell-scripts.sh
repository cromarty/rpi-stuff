#!/bin/bash

echo "Setting the mode of all shell scripts in this repo recursively to 0755..."

find ./ -name '*.sh' -exec chmod -c 755 {} \;

