#!/bin/bash
SCRIPT_DIR=$(dirname "$0")

cd "$QGIS_SOURCES_DIR" || exit 1

cp -f "$SCRIPT_DIR/CMakePresets.json" "$QGIS_SOURCES_DIR/CMakePresets.json"

echo "🚀 Configuring latest QGIS with GDAL from /opt/gdal, PDAL and with tests"

cmake --preset=configure_with_gdal_312_no_tests 

echo "🚀 Building latest QGIS with GDAL from /opt/gdal, PDAL and with tests"

cmake --build --preset=build_with_GDAL_312_PDAL_tests

# cmake --workflow --preset=test

echo "✅ Latest QGIS build completed"