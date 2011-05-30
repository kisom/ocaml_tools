#!/bin/sh

if [ $UID = 0 ]; then
    BUILD_DIR="$(dirname $(which ocaml))"
    echo "build dir: $BUILD_DIR"
    ocamlmktop -o ${BUILD_DIR}/ocamlunix unix.cma
else
    echo "script must be run as root!"
fi
