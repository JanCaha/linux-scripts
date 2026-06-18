#!/bin/bash
set -euo pipefail

# Install GDAL and related libraries
sudo apt-get install -y \
    libudunits2-dev \
    gdal-bin \
    libgdal-dev \
    libgit2-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libssh-dev \
    qpdf \
    libfontconfig1-dev \
    libgeos-dev \
    postgis

sudo systemctl stop postgresql
sudo systemctl disable postgresql
sudo systemctl is-active postgresql
sudo systemctl is-enabled postgresql