#!/bin/bash
QGIS_DIR=~/QGIS
BRANCH=$(git rev-parse --abbrev-ref HEAD)

cd $QGIS_DIR

if [ "$BRANCH" == "master" ];
then
    BUILD_DIR=build-master
    mkdir $BUILD_DIR
    QGIS_BUILD_DIR=$QGIS_DIR/$BUILD_DIR
    git merge upstream/master --no-edit
else
    BUILD_DIR=build-branch
    QGIS_BUILD_DIR=$QGIS_DIR/$BUILD_DIR
fi

cmake \
    -S $QGIS_DIR \
    -B $QGIS_BUILD_DIR \
    -GNinja \
    -DCMAKE_BUILD_TYPE:STRING=Debug \
    -DWITH_3D:BOOL=ON \
    -DWITH_COPC:BOOL=TRUE \
    -DWITH_SERVER:BOOL=ON

cmake --build $QGIS_BUILD_DIR --target all
$QGIS_BUILD_DIR/output/bin/qgis --profile singleplugin

read -p "Press any key to resume ..."
