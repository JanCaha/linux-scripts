#!/bin/zsh
chmod +x $QGIS_BUILD_DIR/tests/env.sh
source $QGIS_BUILD_DIR/tests/env.sh
export LD_LIBRARY_PATH=$QGIS_BUILD_DIR/lib