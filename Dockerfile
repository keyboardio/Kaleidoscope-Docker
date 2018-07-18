## Copyright (C) 2018 Gergely Nagy
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## 1. Redistributions of source code must retain the above copyright notice,
## this list of conditions and the following disclaimer.
##
## 2. Redistributions in binary form must reproduce the above copyright notice,
## this list of conditions and the following disclaimer in the documentation
## and/or other materials provided with the distribution.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
## AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
## ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
## LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
## CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
## SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
## INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
## CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
## ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
## POSSIBILITY OF SUCH DAMAGE.

FROM debian:stable-slim

RUN apt-get update
RUN apt-get install -y curl git-core make xz-utils

WORKDIR /opt
RUN curl https://downloads.arduino.cc/arduino-1.8.5-linux64.tar.xz \
    | tar xJf -
ENV ARDUINO_PATH /opt/arduino-1.8.5

WORKDIR /src/firmware
RUN git clone https://github.com/keyboardio/Arduino-Boards.git hardware/keyboardio/avr \
    && cd hardware/keyboardio/avr \
    && make maintainer-update-submodules
ENV BOARD_HARDWARE_PATH /src/firmware/hardware

VOLUME /src/firmware/src
VOLUME /src/firmware/output

COPY files/entrypoint.sh /opt

ENTRYPOINT ["/opt/entrypoint.sh"]
