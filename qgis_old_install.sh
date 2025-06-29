#!/bin/bash
# list available versions of QGIS
apt list -a qgis

# select version
VERSION="1:3.42.3+40noble-ubuntugis"

# purge previsous QGIS installation
sudo apt-get remove --purge '*qgis*'

# install selected version
sudo apt install \
    qgis=$VERSION \
    qgis-common=$VERSION \
    qgis-providers-common=$VERSION \
    python3-qgis=$VERSION \
    qgis-providers=$VERSION \
    python3-qgis-common=$VERSION \
    libqgis-core=$VERSION
