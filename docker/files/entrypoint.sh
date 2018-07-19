#! /bin/sh
set -e

cd /src/firmware/sketch

if [ -e /src/firmware/config/kaleidoscope-builder.conf ]; then
    cp /src/firmware/config/kaleidoscope-builder.conf .
fi

if [ -e Makefile ]; then
    make $@
else
    /src/firmware/hardware/keyboardio/avr/libraries/Kaleidoscope/bin/kaleidoscope-builder $@
fi
