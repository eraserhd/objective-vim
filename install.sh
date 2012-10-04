#!/bin/bash

set -e
cd /tmp
rm -rf objective-vim
printf 'Getting sources... '
git clone https://github.com/eraserhd/objective-vim.git >/tmp/objective-vim.log
printf 'OK\n'
cd ./objective-vim
objective_vim_develop= ./build.sh
cd ..
rm -rf objective-vim
