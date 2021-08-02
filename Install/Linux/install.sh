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
    CMAKE_BUILD_TYPE_ARG="-DCMAKE_BUILD_TYPE=DEBUG"
elif test \( \( -n "$1" \) -a \( "$1" = "release" \) \);then
    CMAKE_BUILD_TYPE_ARG="-DCMAKE_BUILD_TYPE=RELEASE"
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
# CMAKE GENERATION
# **************************************************************************
mkdir -p "${GV_ROOT}/Generated_Linux/Library"
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ${CMAKE_BUILD_TYPE_ARG} -S "${GV_ROOT}/Development/Library" -B "${GV_ROOT}/Generated_Linux/Library"

mkdir -p "${GV_ROOT}/Generated_Linux/Tools"
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ${CMAKE_BUILD_TYPE_ARG} -S "${GV_ROOT}/Development/Tools" -B "${GV_ROOT}/Generated_Linux/Tools"

mkdir -p "${GV_ROOT}/Generated_Linux/Tutorials/ViewerPlugins"
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ${CMAKE_BUILD_TYPE_ARG} -S "${GV_ROOT}/Development/Tutorials/ViewerPlugins" -B "${GV_ROOT}/Generated_Linux/Tutorials/ViewerPlugins"

mkdir -p "${GV_ROOT}/Generated_Linux/Tutorials/Demos"
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ${CMAKE_BUILD_TYPE_ARG} -S "${GV_ROOT}/Development/Tutorials/Demos" -B "${GV_ROOT}/Generated_Linux/Tutorials/Demos"

mkdir -p "${GV_ROOT}/External/CommonLibraries/cudpp-2.1/build"
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ${CMAKE_BUILD_TYPE_ARG} -S "${GV_ROOT}/External/CommonLibraries/cudpp-2.1" -B "${GV_ROOT}/External/CommonLibraries/cudpp-2.1/build"

# **************************************************************************
# COPY DATA AND SHADERS
# **************************************************************************
cd "${GV_ROOT}/Install/Linux"
./updateData.sh
./updateShaders.sh

# **************************************************************************
# BUILD Externals Libraries
# **************************************************************************

# Build externals libraries - cudpp
cmake --build "${GV_ROOT}/External/CommonLibraries/cudpp-2.1/build" ${CMAKE_CONFIG_TYPE_ARG} -- -j

# Build externals libraries - glew
make -C "${GV_ROOT}/External/CommonLibraries/glew-1.12.0"
