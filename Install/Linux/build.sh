#!/bin/bash

# Exit script on error
set -e

if test \( $# -ne 1 \);
then
    echo "Usage: build.sh config platform arch"
    echo ""
    echo "Configs:"
    echo "  debug   -   build with the debug configuration"
    echo "  release -   build with the release configuration"
    echo ""
    exit 1
fi

if test \( \( -n "$1" \) -a \( "$1" = "debug" \) \);then 
    CMAKE_CONFIG_TYPE_ARG="--config DEBUG"
elif test \( \( -n "$1" \) -a \( "$1" = "release" \) \);then
    CMAKE_CONFIG_TYPE_ARG="--config RELEASE"
else
    echo "The config \"$1\" is not supported!"
    echo ""
    echo "Configs:"
    echo "  debug   -   build with the debug configuration"
    echo "  release -   build with the release configuration"
    echo ""
    exit 1
fi

# Set the working directory correctly
GV_ROOT="$(cd "$(dirname "$0")/../.." 1>/dev/null 2>/dev/null && pwd)"

# Use NVCC matched CXX
export CC=clang-8
export CXX=clang++-8
export CUDAHOSTCXX=clang++-8

# **************************************************************************
# BUILD GigaSpace
# **************************************************************************

cmake --build "${GV_ROOT}/Generated_Linux/Library" ${CMAKE_CONFIG_TYPE_ARG} -- -j
cmake --build "${GV_ROOT}/Generated_Linux/Tools" ${CMAKE_CONFIG_TYPE_ARG} -- -j
cmake --build "${GV_ROOT}/Generated_Linux/Tutorials/Demos" ${CMAKE_CONFIG_TYPE_ARG} -- -j
cmake --build "${GV_ROOT}/Generated_Linux/Tutorials/ViewerPlugins" ${CMAKE_CONFIG_TYPE_ARG} #-- -j
