#! /bin/bash
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

usage() {
    cat <<EOF
Usage: $0 [options] [builder-parameters...]

Options:
  -s SKETCH_DIR     -- Use SKETCH_DIR as the sketch source. Defaults to '.'.
  -o OUTPUT_DIR     -- Put build artifacts into OUTPUT_DIR. Defaults to './output'.
  -h                -- This help screen.
EOF
}

docker build --quiet --rm -t local/kaleidoscope-builder . >/dev/null

if [ $# -lt 1 ]; then
    usage >&2
    exit 1
fi

SKETCH="$(pwd)"
OUTPUT="$(pwd)/output"

while getopts ":s:oh" o; do
    case "${o}" in
        s)
            SKETCH="${OPTARG}"
            ;;
        o)
            OUTPUT="${OPTARG}"
            ;;
        'h')
            usage
            exit 0
            ;;
    esac
done
shift $(expr $OPTIND - 1)

docker run -ti                           \
       -v ${SKETCH}:/src/firmware/src    \
       -v ${OUTPUT}:/src/firmware/output \
       local/kaleidoscope-builder $@

ls -la ${OUTPUT}/*.hex
