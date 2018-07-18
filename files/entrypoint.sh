#! /bin/sh
set -e

cp -r /src/firmware/src/ /src/firmware/sketch
rm -rf /src/firmware/sketch/.git

cd /src/firmware/sketch
git init --quiet
git config user.name Docker
git config user.email docker@example.com
git commit --quiet --allow-empty -m init

if [ -e Makefile ]; then
    make $@
else
    /src/firmware/hardware/keyboardio/avr/libraries/Kaleidoscope/bin/kaleidoscope-builder $@
fi

cp output/*/*-latest.* /src/firmware/output
