#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: docker-build <host-src> <host-build>"
  exit 1
fi

function info() {
  echo $*
}

function run() {
  echo " -- $*"
  $*
}

HOST_SOURCE_DIR="$1"
HOST_BUILD_DIR="$2"
BUILD_IMAGE=h5view_devel

# make sure devel image is up-to-date
info Building development image
run docker build "$HOST_SOURCE_DIR/docker" -t $BUILD_IMAGE

# build
info Building h5view
run docker run \
  --rm \
  --volume "$HOST_SOURCE_DIR:/h5view_src" \
  --volume "$HOST_BUILD_DIR:/h5view_build" \
  "$BUILD_IMAGE" /h5view_src/scripts/build.sh /h5view_src /h5view_build
