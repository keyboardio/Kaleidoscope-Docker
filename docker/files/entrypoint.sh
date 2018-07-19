#! /bin/sh
set -e

cd /src/firmware/sketch

cp /src/firmware/config/kaleidoscope-builder.conf .

/src/firmware/hardware/keyboardio/avr/libraries/Kaleidoscope/bin/kaleidoscope-builder build $@

install -d /src/firmware/output/tools
install /opt/teensy_loader_cli /usr/bin/avrdude /src/firmware/output/tools

chown -R "${OWNER}" /src/firmware/output
