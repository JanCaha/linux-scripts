#!/bin/bash
set -euo pipefail

# Install QGIS
sudo apt-get install -y \
    qgis \
    libqgis-dev \
    qgis-plugin-grass