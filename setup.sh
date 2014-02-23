#!/bin/bash

git clone https://github.com/denny0223/rc-files.git

# backup origin rc-files
mkdir rc_backup
cd rc-files
find . -maxdepth 1 ! -path . ! -path ./.git ! -path ./setup.sh -exec mv ../{} ../rc_backup/ \;

cd ..
find rc-files/ -maxdepth 1 ! -path rc-files/ ! -path rc-files/.git ! -path rc-files/setup.sh -exec ln -s {} . \;
