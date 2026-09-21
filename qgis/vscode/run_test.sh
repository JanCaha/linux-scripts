#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd build
filename=$(basename "$1")
module=$(basename "$(dirname "$1")")
testname=${filename//test/}
testname=${testname//qgs/}
testname=${testname//.cpp/}
echo "Running test: $testname"
ctest --output-on-failure --verbose -R test_${module}_${testname}