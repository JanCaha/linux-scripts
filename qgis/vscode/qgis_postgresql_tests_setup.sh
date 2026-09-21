#!/bin/bash
export PGHOST
export PGPORT
export PGUSER
export PGPASSWORD

bash "$QGIS_SOURCES_DIR/tests/testdata/provider/testdata_pg.sh"
