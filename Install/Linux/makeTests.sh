#!/bin/bash
# Exit script on error
set -e

# Set the working directory correctly
cd "$(dirname "$0")"

# **************************************************************************
# CMAKE GENERATION
# **************************************************************************
GV_ROOT=`(cd ../.. && pwd)`

# Generates standard UNIX makefiles
mkdir -p $GV_ROOT/Generated_Linux/Tests

# Generates standard UNIX makefiles
cd $GV_ROOT/Generated_Linux/Tests
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON $GV_ROOT/Development/Tests
