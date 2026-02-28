#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export PYTHONPATH="$SCRIPT_DIR/../build/output/python:$SCRIPT_DIR/../build/output/python/plugins:$SCRIPT_DIR/../tests/src/python"
export LD_LIBRARY_PATH="$SCRIPT_DIR/../build/output/lib:${LD_LIBRARY_PATH}"
export QGIS_PREFIX_PATH="$SCRIPT_DIR/../build/output"
export QT_QPA_PLATFORM=offscreen
export QGIS_DEBUG=1

cd build
filename=$(basename "$1")
module=$(basename "$(dirname "$1")")
testname=${filename//test/}
testname=${testname//qgs/}
testname=${testname//.cpp/}
echo "Running test: $testname"
ctest --output-on-failure --verbose -R test_${module}_${testname}