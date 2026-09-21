#!/bin/bash
QGIS_VERSION=3.40

# check that conda is available
if ! command -v conda &> /dev/null; then
    echo "Error: conda is not available."
    exit 1
fi

# Source conda setup to enable conda activate in this script
source "$(conda info --base)/etc/profile.d/conda.sh"

# check that specific env exist
if ! conda info --envs | grep -q "^qgis-ltr"; then
    echo "Creating conda environment qgis-ltr..."
    conda create -y -n qgis-ltr -c conda-forge qgis=$QGIS_VERSION
    conda activate qgis-ltr
else
    conda activate qgis-ltr
    # check qgis version
    if ! qgis --version | grep -q "$QGIS_VERSION"; then
        echo "Updating qgis-ltr environment to QGIS version $QGIS_VERSION..."
        conda install -y -c conda-forge qgis=$QGIS_VERSION
    fi
fi

qgis
