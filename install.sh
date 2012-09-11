#!/bin/bash

set -e
cd /tmp
rm -rf objvim
git clone https://github.com/eraserhd/objvim.git
cd ./objvim
objvim_develop= ./build.sh
cd ..
rm -rf objvim
