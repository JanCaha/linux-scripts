#!/bin/zsh
_srcdir=$QGIS_SOURCES_DIR
_builddir=$QGIS_BUILD_DIR

if expr "${_builddir}" : "@" >/dev/null || test -z "${_builddir}" ||
    expr "${_srcdir}" : "@" >/dev/null || test -z "${_srcdir}"; then
    echo "This File, it wasn't generated properly." >&2
    return 1
fi

export srcdir=${_srcdir}
export builddir=${_builddir}

export QGIS_PREFIX_PATH=${builddir}/output
export PYTHONPATH=${builddir}/output/python:$PYTHONPATH

export LD_LIBRARY_PATH=${builddir}/output/lib:$LD_LIBRARY_PATH
