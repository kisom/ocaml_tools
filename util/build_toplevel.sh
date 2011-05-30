#!/bin/sh
# file: build_toplevel.sh
# author: kyle isom <coder@kyleisom.net>
# license: ISC / public domain dual-licensed
#
# bakes a new toplevel with useful libs built-in

BAKED_IN="unix.cma lwt_unix.cma"
LIB_DIR=""

if [ $UID = 0 ]; then
    # add to the same directory as the current top-level
    BUILD_DIR="$(dirname $(which ocaml))"
    BUILD_DIR=/opt/local/bin

    # assumes that the libraries are in the same prefix as the BUILD_DIR
    LIB_DIR=${BUILD_DIR%bin}/lib/ocaml

    if [ ! -x ${LIB_DIR} ]; then
	echo "can't find library directory!"
	exit 1
    fi

    INCLUDE="-I ${LIB_DIR}/lwt"
    echo "including $INCLUDE"
    BUILD_DIR="."

    echo "build dir: $BUILD_DIR"
    ocamlfind ocamlmktop -o ${BUILD_DIR}/ocamlunix ${INCLUDE} ${BAKED_IN}
else
    echo "script must be run as root!"
fi
