#!/bin/bash
set -euo pipefail

if [[ ! -d "~/.local/bin" ]]; then
    mkdir -p ~/.local/bin
fi

source /etc/os-release

BASEDIR=$(dirname "$(readlink -f "$0")")
PATH=$PATH:$BASEDIR/python_programs

echo "Starting the complete install script from $BASEDIR"

# source prepare_sources.sh

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y

# basic stuff
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
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
    eiciel \
    tesseract-ocr \
    vsftpd \
    wakeonlan \
    openssh-server \
    baobab \
    smbclient \
    default-jdk \
    gnome-panel \
    gparted \
    konsole \
    kate \
    kompare \
    krename

# numlockx

# GitHub CLI
cd /tmp
GH_VERSION=$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)
wget https://github.com/cli/cli/releases/download/$GH_VERSION/gh_${GH_VERSION#v}_linux_amd64.deb
sudo dpkg -i gh_${GH_VERSION#v}_linux_amd64.deb
# sudo apt-get install -y gh

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
    pre-commit \
    astyle \
    flip \
    ccache

# Fd - find replacement
sudo apt-get install -y fd-find
ln -s "$(which fdfind)" ~/.local/bin/fd

# redshift
sudo apt-get remove -y redshift-gtk
rm -f ~/.config/redshift.conf
sudo apt-get install -y redshift

# GIT
sudo apt-get -y install git git-crypt

# Docker
sudo apt-get install -y \
    docker.io \
    docker-compose

sudo groupadd docker || true
if [[ -n "${USER:-}" ]]; then
    sudo usermod -aG docker $USER
fi

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
    pipx \
    python3-pip \
    python-is-python3

# QGIS
sudo apt-get install -y \
    qgis \
    libqgis-dev \
    qgis-plugin-grass

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
sudo apt-get install -y nemo cinnamon-control-center xdg-utils krusader


# Onedrive
source $BASEDIR/install/onedrive.sh

# Calibre
sudo apt-get install -y libxcb-cursor0
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin

# Joplin
cd /tmp
wget -O joplin_install.sh https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh
bash joplin_install.sh --allow-root

# Brave
curl -fsS https://dl.brave.com/install.sh | sh

# WEBP PEEK
sudo apt-get install -y \
    peek

# Quarto
cd /tmp
sudo curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
sudo gdebi quarto-linux-amd64.deb

# QtCreator
sudo apt-get install -y qtcreator

# Strawberry
sudo apt-get install -y strawberry

# ZSH
source $BASEDIR/install/zsh.sh

# CMake
sudo apt-get install -y cmake

# QGIS compile
sudo apt-get install -y \
    bison build-essential ca-certificates ccache cmake cmake-curses-gui dh-python \
    expect flex flip gdal-bin git graphviz grass-dev libcups2-dev libdraco-dev libexiv2-dev \
    libexpat1-dev libfcgi-dev libgdal-dev libgeographiclib-dev libgeos-dev libgsl-dev \
    libmeshoptimizer-dev libpq-dev libproj-dev libprotobuf-dev libqca-qt6-dev \
    libqca-qt6-plugins libqscintilla2-qt6-dev libsfcgal-dev libspatialite-dev libsqlite3-dev \
    libsqlite3-mod-spatialite libyaml-tiny-perl libzip-dev libzstd-dev lighttpd locales ninja-build \
    nlohmann-json3-dev ocl-icd-opencl-dev opencl-headers pandoc pkgconf poppler-utils protobuf-compiler \
    pyqt6-dev pyqt6-dev-tools pyqt6.qsci-dev python3-all-dev python3-autopep8 python3-dev python3-gdal \
    python3-matplotlib python3-mock python3-nose2 python3-owslib python3-packaging python3-psycopg2 \
    python3-pyqt6 python3-pyqt6.qsci python3-pyqt6.qtmultimedia python3-pyqt6.qtpositioning python3-pyqt6.qtserialport \
    python3-pyqt6.qtsvg python3-pyqt6.sip python3-pyqtbuild python3-termcolor python3-yaml qt6-3d-assimpsceneimport-plugin \
    qt6-3d-defaultgeometryloader-plugin qt6-3d-dev qt6-3d-gltfsceneio-plugin qt6-3d-scene2d-plugin qt6-5compat-dev \
    qt6-base-dev qt6-base-private-dev qt6-multimedia-dev qt6-positioning-dev qt6-serialport-dev qt6-svg-dev qt6-tools-dev \
    qt6-tools-dev-tools qt6-webengine-dev qtkeychain-qt6-dev sip-tools spawn-fcgi xauth xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable xvfb

# PDAL
sudo apt-get install -y libgeotiff-dev geotiff-bin

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

# PgAdmin
sudo apt-get install -y \
    libpq-dev libpqxx-dev # libraries

# LibreOffice style
sudo apt-get install -y libreoffice-style-karasa-jaga

# UFW and GUI for it
sudo apt install ufw gufw -y

# add install from sepearate scripts
source $BASEDIR/install/miniconda.sh
source $BASEDIR/install/rust.sh
source $BASEDIR/install/jellyfin.sh
source $BASEDIR/install/texlive.sh
source $BASEDIR/install/r.sh
source $BASEDIR/install/xnview.sh
source $BASEDIR/install/drivers-nvidia.sh

