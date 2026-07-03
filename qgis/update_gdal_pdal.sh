#!/bin/zsh
set -e

GDAL_DIR="$HOME/Codes/Install/gdal"
PDAL_DIR="$HOME/Codes/Install/PDAL"
GDAL_PREFIX="/opt/gdal"
PDAL_PREFIX="/opt/pdal"

echo "🚀 Updating GDAL from $GDAL_DIR"

cd "$GDAL_DIR"
git pull

rm -rf build
mkdir build
cd build

cmake .. \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$GDAL_PREFIX" \
    -DBUILD_SHARED_LIBS="ON" \
    -DCMAKE_CXX_FLAGS="-DGDAL_DEBUG"

cmake --build .
sudo cmake --build . --target install

echo "✅ GDAL build and install completed"

echo "🚀 Updating PDAL from $PDAL_DIR"

cd "$PDAL_DIR"
git pull

rm -rf build
mkdir -p build
cd build

cmake .. \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_INSTALL_PREFIX="$PDAL_PREFIX" \
    -DBUILD_SHARED_LIBS="ON" \
    -DCMAKE_PREFIX_PATH="$GDAL_PREFIX" \
    -DGDAL_ROOT="$GDAL_PREFIX" \
    -DCMAKE_CXX_FLAGS="-DGDAL_DEBUG" \
    -DWITH_TESTS="ON"

cmake --build .
sudo cmake --install .

echo "✅ PDAL build and install completed"
