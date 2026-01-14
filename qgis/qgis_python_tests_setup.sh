#!/bin/zsh

# First parameter: true/false flag (default: false)
USE_GDAL_OPT="${1:-false}"

# Validate parameter
if [[ "$USE_GDAL_OPT" != "true" && "$USE_GDAL_OPT" != "false" ]]; then
    echo "Error: First parameter must be 'true' or 'false'"
    echo "Usage: $0 [true|false]"
    exit 1
fi

if [[ "$USE_GDAL_OPT" == "true" ]]; then
    echo "Using GDAL in /opt/gdal"
    GDAL_PYTHONPATH=/opt/gdal/local/lib/python3.13/dist-packages
    GDAL_LD_LIBRARY_PATH=/opt/gdal/lib
else
    echo "Using system GDAL"
fi

_srcdir=$(pwd)
_builddir=$(pwd)/build-qt

if expr "${_builddir}" : "@" >/dev/null || test -z "${_builddir}" ||
    expr "${_srcdir}" : "@" >/dev/null || test -z "${_srcdir}"; then
    echo "This File, it wasn't generated properly." >&2
    return 1
fi

export srcdir=${_srcdir}
export builddir=${_builddir}

export QGIS_PREFIX_PATH=${builddir}/output
export PYTHONPATH=${builddir}/output/python:${builddir}/output/python/plugins:${builddir}/tests/src/python:$PYTHONPATH:$GDAL_PYTHONPATH

export LD_LIBRARY_PATH=${builddir}/output/lib:$LD_LIBRARY_PATH:$GDAL_LD_LIBRARY_PATH