#!/bin/bash
QGIS_DIR=~/QGIS
cd $QGIS_DIR

BRANCH=$(git rev-parse --abbrev-ref HEAD)

CMAKE_SETTINGS="-G Ninja -DWITH_SERVER:BOOL=ON -DWITH_3D:BOOL=ON -DWITH_COPC:BOOL=TRUE -DWITH_PDAL:BOOL=TRUE"

if [ $BRANCH == "master" ];
then
    BUILD_DIR=build-master
    mkdir $BUILD_DIR
    QGIS_BUILD_DIR=$QGIS_DIR/$BUILD_DIR
    git stash
    git pull upstream
    git merge upstream/master --no-edit
    git stash pop
else
    BUILD_DIR=build-branch
    QGIS_BUILD_DIR=$QGIS_DIR/$BUILD_DIR
fi

cmake \
    -S $QGIS_DIR \
    -B $QGIS_BUILD_DIR \
    -GNinja \
    -DCMAKE_BUILD_TYPE:STRING=Debug \
    $CMAKE_SETTINGS

cmake --build $QGIS_BUILD_DIR --target all
$QGIS_BUILD_DIR/output/bin/qgis

read -p "Press any key to resume ..."
