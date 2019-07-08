#!/bin/bash

# Build project with CMake

SOURCE_DIR="$1"
BUILD_DIR="$2"

cd $BUILD_DIR
cmake -G Ninja -DUSE_SYSTEM=ON $SOURCE_DIR
cmake --build .
