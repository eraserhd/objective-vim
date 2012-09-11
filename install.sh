#!/bin/bash

set -e
cd /tmp
rm -rf objvim
printf 'Getting sources... '
git clone https://github.com/eraserhd/objvim.git >/tmp/objvim.log
printf 'OK\n'
cd ./objvim
objvim_develop= ./build.sh
cd ..
rm -rf objvim
