#!/bin/bash
source /etc/os-release

BASEDIR=$(dirname "$(readlink -f "$0")")
PATH=$PATH:$BASEDIR/python

# source prepare_sources.sh

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y
sudo apt-get install -y mintupgrade

# basic stuff
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    wget \
    gdebi-core \
    gdebi \
    gedit \
    gimp \
    inkscape \
    scribus \
    keepassxc \
    filezilla \
    sqlitebrowser \
    ncftp \
    umbrello \
    zanshin \
    dia \
    chromium \
    gpick \
    webp \
    konsole \
    vlc \
    kate \
    lsb-release \
    dirmngr \
    build-essential \
    libcurl4-openssl-dev \
    libsqlite3-dev \
    pkg-config \
    libnotify-dev \
    ksnip \
    okular \
    jq \
    git-buildpackage \
    krita \
    handbrake \
    eiciel \
    tesseract-ocr \
    vsftpd \
    wakeonlan \
    openssh-server
# numlockx

# mtp for android devices
sudo apt-get install -y \
    mtp-tools \
    jmtpfs \
    gvfs-backends \
    gvfs-fuse \
    libmtp-runtime

# C++ dev tools
sudo apt-get install -y \
    clang \
    lld \
    libclang-dev \
    ninja-build \
    doxygen \
    cmake \
    devscripts \
    libgtest-dev \
    libgmock-dev \
    libpqxx-dev \
    clang-format \
    google-perftools \
    valgrind \
    silversearcher-ag \
    expect \
    shellcheck \
    pre-commit

# Fd - find replacement
sudo apt-get install -y fd-find
ln -s $(which fdfind) ~/.local/bin/fd

# redshift
sudo apt-get remove -y redshift-gtk
rm ~/.config/redshift.conf
sudo apt-get install -y redshift

# GIT
sudo apt-get -y install git

# Docker
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin \
    docker-compose

sudo groupadd docker
sudo usermod -aG docker $USER

# Python Packages
sudo apt-get install -y \
    python3-pip \
    python3-pybind11 \
    python3-venv \
    python3-debugpy \
    python3-jupyter-core \
    python3-ipykernel \
    python3-nbclient \
    python3-flake8-black \
    python3-pycodestyle \
    python3-isort \
    python3-mypy \
    python3-pytest \
    python3-pytest-cov \
    python3-pytestqt \
    pipx

# QGIS
sudo apt-get install -y \
    qgis \
    libqgis-dev

# GRASS
sudo apt-get install -y \
    grass-gui

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
    libgeos-dev

# Krusader
# sudo apt-get install -y \
#     extra-cmake-modules \
#     libkf5archive-dev \
#     libkf5doctools-dev \
#     libkf5kio-dev \
#     libkf5notifications-dev \
#     libkf5parts-dev \
#     libkf5wallet-dev \
#     libkf5xmlgui-dev

# cd /tmp
# git clone https://invent.kde.org/utilities/krusader
# cd krusader
# cmake -DCMAKE_INSTALL_PREFIX=/usr/ -DCMAKE_C_FLAGS="-O2 -fPIC" -DCMAKE_CXX_FLAGS="-O2 -fPIC"
# sudo make install
sudo apt-get install -y krusader

# Onedrive
source install/onedrive.sh

# Calibre
sudo apt-get install -y libxcb-cursor0
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin

# Joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash

# Brave
sudo apt-get install -y brave-browser

# WEBP PEEK
sudo apt-get install -y \
    peek

# GitHub CLI
sudo apt-get install -y gh

# Quarto
cd /tmp
sudo curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
sudo gdebi quarto-linux-amd64.deb

# QtCreator
sudo apt-get install -y qtcreator

# Strawberry
sudo apt-get install -y strawberry

# ZSH
source install/zsh.sh

# CMake
sudo apt-get install -y cmake

# QGIS compile
sudo apt-get install -y \
    flex bison libzip-dev libprotobuf-dev libexiv2-dev libdraco-dev \
    pyqt6-dev pyqt6-dev-tools libqca-qt6-dev libqca-qt6-plugins libqscintilla2-qt6-dev \
    qt6-3d-defaultgeometryloader-plugin qt6-3d-dev qt6-3d-gltfsceneio-plugin qt6-3d-scene2d-plugin \
    qt6-5compat-dev qt6-base-dev qt6-base-private-dev qt6-multimedia-dev qt6-positioning-dev \
    qt6-serialport-dev qt6-svg-dev qt6-tools-dev qt6-tools-dev-tools qt6-webengine-dev 
    qtkeychain-qt6-dev pyqt6.qsci-dev libgsl-dev \
    libspatialite-dev sip-tools protobuf-compiler ocl-icd-opencl-dev opencl-headers \
    libhdf5-dev libhdf5-serial-dev hdf5-tools libnetcdf-dev netcdf-bin libsfcgal-dev

# PDAL
libgeotiff-dev geotiff-bin


sudo apt-get install -y \
    python3-pyqt6 \
    python3-pyqt6.qsci \
    python3-pyqt6.qtbluetooth \
    python3-pyqt6.qtcharts \
    python3-pyqt6.qtdesigner \
    python3-pyqt6.qthelp \
    python3-pyqt6.qtmultimedia \
    python3-pyqt6.qtnfc \
    python3-pyqt6.qtpdf \
    python3-pyqt6.qtpositioning \
    python3-pyqt6.qtqml \
    python3-pyqt6.qtquick3d \
    python3-pyqt6.qtquick \
    python3-pyqt6.qtremoteobjects \
    python3-pyqt6.qtsensors \
    python3-pyqt6.qtserialport \
    python3-pyqt6.qtsvg \
    python3-pyqt6.qttexttospeech \
    python3-pyqt6.qtwebchannel \
    python3-pyqt6.qtwebengine \
    python3-pyqt6.qtwebsockets \
    python3-pyqt6.sip \
    python3-gdal     

pip install sip pyqt-builder owslib psycopg2 --break-system-packages


# PgAdmin
sudo apt-get install -y \
    pgadmin4 \
    libpq-dev libpqxx-dev # libraries

# LibreOffice style
sudo apt-get install -y libreoffice-style-karasa-jaga

# Turtle
sudo apt-get install -y turtle-cli turtle-nautilus

# add install from sepearate scripts
$BASEDIR/install/miniconda.sh
$BASEDIR/install/rust.sh
$BASEDIR/install/jellyfin.sh
$BASEDIR/install/texlive.sh
$BASEDIR/install/r.sh
$BASEDIR/install/xnview.sh
