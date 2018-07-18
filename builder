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
  -O OPTION         -- Additional builder options (see below).
  -h                -- This help screen.

Builder options (-O):
  plugin-v2         -- Build with the V1 plugin API disabled.
EOF
}

docker build --quiet --rm -t local/kaleidoscope-builder . >/dev/null

if [ $# -lt 1 ]; then
    usage >&2
    exit 1
fi

SKETCH="$(pwd)"
OUTPUT="$(pwd)/output"
OPTIONS=""

while getopts ":s:o:O:h" o; do
    case "${o}" in
        s)
            SKETCH="${OPTARG}"
            ;;
        o)
            OUTPUT="${OPTARG}"
            ;;
        O)
            OPTIONS="${OPTIONS} ${OPTARG}"
            ;;
        h)
            usage
            exit 0
            ;;
    esac
done
shift $((OPTIND - 1))

KALEIDOSCOPE_LOCAL_CFLAGS=""
for opt in ${OPTIONS}; do
    case $opt in
        plugin-v2)
            KALEIDOSCOPE_LOCAL_CFLAGS="${KALEIDOSCOPE_LOCAL_CFLAGS} -DKALEIDOSCOPE_ENABLE_V1_PLUGIN_API=0"
            ;;
    esac
done

CFGDIR=$(mktemp -d)

if [ ! -z "${KALEIDOSCOPE_LOCAL_CFLAGS}" ]; then
    cat >>"${CFGDIR}/kaleidoscope-builder.conf" <<EOF
LOCAL_CFLAGS="${KALEIDOSCOPE_LOCAL_CFLAGS}"
EOF
fi

case "${SKETCH}" in
    https://*|http://*|git@*|git://|git+ssh://)
        git clone -q "${SKETCH}" "${CFGDIR}/sketch"
        SKETCH="${CFGDIR}/sketch"
        ;;
esac

docker run -ti                           \
       -v "${SKETCH}:/src/firmware/src"    \
       -v "${OUTPUT}:/src/firmware/output" \
       -v "${CFGDIR}:/src/firmware/config" \
       local/kaleidoscope-builder "$@"

rm -rf "${CFGDIR}"

ls -la "${OUTPUT}"/*.hex
