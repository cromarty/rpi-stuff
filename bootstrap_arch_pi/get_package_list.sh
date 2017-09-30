#!/bin/bash

pacman -Qe | awk '{print $1}' > package_list.txt

