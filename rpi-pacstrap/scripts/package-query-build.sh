#!/bin/bash
# dep: yajl
git clone https://aur.archlinux.org/package-query.git
cd package-query
makepkg
cd ..
git clone https://aur.archlinux.org/yaourt.git
cd yaourt
makepkg
cd ..

