#!/bin/bash
set -euo pipefail

if [[ ! -d ~/.local/bin ]]; then
    mkdir -p ~/.local/bin
fi

source /etc/os-release

IS_DEBIAN=0

if [[ "$ID" == "debian" ]]; then
    IS_DEBIAN=1
fi

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PATH=$PATH:$SCRIPT_DIR/python_programs

echo "Starting the complete install script from $SCRIPT_DIR"

# source prepare_sources.sh

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y

# basic stuff
source $SCRIPT_DIR/install/basic_software.sh

# GitHub CLI
source $SCRIPT_DIR/install/github_cli.sh

# mtp for android devices
source $SCRIPT_DIR/install/android.sh

# C++ dev tools
source $SCRIPT_DIR/install/cpp_dev_tools.sh

# Fd - find replacement
source $SCRIPT_DIR/install/fd_find.sh

# redshift
source $SCRIPT_DIR/install/redshift.sh

# GIT
source $SCRIPT_DIR/install/git.sh

# Docker
source $SCRIPT_DIR/install/docker.sh

# Python Packages
source $SCRIPT_DIR/install/python_packages.sh

# GIS
source $SCRIPT_DIR/install/gis_libs.sh
source $SCRIPT_DIR/install/grass.sh
source $SCRIPT_DIR/install/qgis.sh

# Onedrive
source $SCRIPT_DIR/install/onedrive.sh

# Calibre
source $SCRIPT_DIR/install/calibre.sh

# Joplin
source $SCRIPT_DIR/install/joplin.sh

# Brave
source $SCRIPT_DIR/install/brave.sh

# WEBP PEEK
source $SCRIPT_DIR/install/webp_peek.sh

# Quarto
source $SCRIPT_DIR/install/quarto.sh

# QtCreator
sudo apt-get install -y qtcreator

# Strawberry
source $SCRIPT_DIR/install/strawberry.sh

# ZSH
source $SCRIPT_DIR/install/zsh.sh

# CMake
source $SCRIPT_DIR/install/cmake.sh

# QGIS compile
source $SCRIPT_DIR/install/qgis_compile.sh

# PDAL
source $SCRIPT_DIR/install/pdal.sh

# PgAdmin
source $SCRIPT_DIR/install/pg.sh

# LibreOffice style
source $SCRIPT_DIR/install/libreoffice_style.sh

# UFW and GUI for it
source $SCRIPT_DIR/install/ufw.sh

# Krusader
source $SCRIPT_DIR/install/krusader.sh

# add install from sepearate scripts
source $SCRIPT_DIR/install/conda.sh
source $SCRIPT_DIR/install/rust.sh
source $SCRIPT_DIR/install/r.sh
source $SCRIPT_DIR/install/xnview.sh

if [[ "$GITHUB_ACTIONS" != "true" ]]; then
    source $SCRIPT_DIR/install/drivers-nvidia.sh
fi

if [[ $IS_DEBIAN -eq 0 ]]; then
    source $SCRIPT_DIR/install/jellyfin.sh
fi