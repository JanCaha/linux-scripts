#!/bin/bash
source /etc/os-release

KEYS_FOLDER=/usr/share/keyrings
SOURCES_FOLDER=/etc/apt/sources.list.d

QGIS_UNSTABLE=false

source prepare_sources.sh

sudo apt-get update 
sudo apt-get upgrade -y 
sudo apt autoremove -y
sudo apt-get install mintupgrade 

# basic stuff
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    wget \
    gdebi-core \
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
    dropbox \
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
    numlockx \
    jq

# Clang
sudo apt-get install -y \
    clang \
    clang-14 \
    lld-14 \
    libclang-14-dev \
    ninja-build \
    g++-12 \
    doxygen \
    cmake \
    devscripts \
    libgtest-dev \
    libgmock-dev \
    libpqxx-dev \
    clang-format

# Fd - find replacement
sudo apt-get install -y fd-find
ln -s $(which fdfind) ~/.local/bin/fd

# redshift
sudo apt-get remove -y redshift-gtk
rm ~/.config/redshift.conf
sudo apt-get install -y redshift

# GIT
sudo apt update
sudo apt upgrade -y
sudo apt-get -y install git

# Docker
sudo apt-get update
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin \
    docker-compose

sudo groupadd docker
sudo usermod -aG docker $USER

# Python Packages
sudo apt install -y python3-pip
pip3 install \
    beautifulsoup4 \
	pylint \
    pb_tool \
	nbclient \
    jupyter-core \
    ipykernel \
	pycodestyle \
    flake8 \
    mypy \
    yapf \
    black \
	mkdocs-bootswatch \
	https://codeload.github.com/mkdocs/mkdocs-bootstrap/zip/master \
	git+https://github.com/it-novum/mkdocs-featherlight.git
	
# QGIS
sudo apt update
sudo apt upgrade -y
sudo apt-get install -y \
    qgis \
    libqgis-dev

# GRASS
sudo apt-get install -y \
    grass-gui

# TinyTeX
# wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh

# R
sudo apt-get update -y
sudo apt-get install -y \
    r-base \
    r-base-dev

sudo apt-get install -y \
	libudunits2-dev \
	gdal-bin \
	libgdal-dev \
	libgit2-dev \
	libharfbuzz-dev \
	libfribidi-dev \
	libssh-dev \
	qpdf \
    libfontconfig1-dev

# Krusader
sudo apt-get install -y \
    extra-cmake-modules \
    libkf5archive-dev \
    libkf5doctools-dev \
    libkf5kio-dev \
    libkf5notifications-dev \
    libkf5parts-dev \
    libkf5wallet-dev \
    libkf5xmlgui-dev

cd /tmp
git clone https://invent.kde.org/utilities/krusader
cd krusader
cmake -DCMAKE_INSTALL_PREFIX=/usr/ -DCMAKE_C_FLAGS="-O2 -fPIC" -DCMAKE_CXX_FLAGS="-O2 -fPIC"
sudo make install

# Onedrive 
curl -fsS https://dlang.org/install.sh | bash -s dmd
sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.gold" 20
sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.bfd" 10

folder=$(fd "^dmd-[0-9\.]+" ~/dlang)
source $folder/activate

cd /tmp
git clone https://github.com/abraunegg/onedrive.git
cd onedrive
./configure
make clean; make;
sudo make install
deactivate

# Calibre
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin

# TexStudio
sudo apt-get update
sudo apt-get install -y texstudio

# Joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash

# Brave
sudo apt-get update
sudo apt-get install -y brave-browser

# WEBP PEEK
sudo apt update
sudo apt install -y \
    peek

# GitHub CLI
sudo apt-get update -y
sudo apt-get install -y gh

# Quarto
cd /tmp
sudo curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
sudo gdebi quarto-linux-amd64.deb

# MiniConda
cd /tmp
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh -b -f -p ~$USER/miniconda3

# QtCreator
sudo apt-get install -y qtcreator

# Strawberry
sudo apt update
sudo apt install -y strawberry

# ZSH
sudo apt install zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
chsh -s $(which zsh)

# NodeJS
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&\
sudo apt-get install -y nodejs npm

# CMake
sudo apt-get update
sudo apt-get install -y cmake

# Rust, Cargo and packages
sudo apt install cargo
cargo install sd
export PATH=~/.cargo/bin:$PATH

# QGIS compile
sudo apt-get install -y \
    bison build-essential ca-certificates ccache cmake cmake-curses-gui dh-python doxygen expect flex flip gdal-bin git graphviz grass-dev libdraco-dev libexiv2-dev libexpat1-dev libfcgi-dev libgdal-dev libgeos-dev libgsl-dev libpdal-dev libpq-dev libproj-dev libprotobuf-dev libqca-qt5-2-dev libqca-qt5-2-plugins libqscintilla2-qt5-dev libqt5opengl5-dev libqt5serialport5-dev libqt5sql5-sqlite libqt5svg5-dev libqt5webkit5-dev libqt5xmlpatterns5-dev libqwt-qt5-dev libspatialindex-dev libspatialite-dev libsqlite3-dev libsqlite3-mod-spatialite libyaml-tiny-perl libzip-dev libzstd-dev lighttpd locales ninja-build ocl-icd-opencl-dev opencl-headers pandoc pdal pkg-config poppler-utils protobuf-compiler pyqt5-dev pyqt5-dev-tools pyqt5.qsci-dev python3-all-dev python3-autopep8 python3-dev python3-gdal python3-jinja2 python3-lxml python3-mock python3-nose2 python3-owslib python3-plotly python3-psycopg2 python3-pygments python3-pyproj python3-pyqt5 python3-pyqt5.qsci python3-pyqt5.qtmultimedia python3-pyqt5.qtpositioning python3-pyqt5.qtsql python3-pyqt5.qtsvg python3-pyqt5.qtwebkit python3-pyqtbuild python3-sip python3-termcolor python3-yaml qt3d-assimpsceneimport-plugin qt3d-defaultgeometryloader-plugin qt3d-gltfsceneio-plugin qt3d-scene2d-plugin qt3d5-dev qtbase5-dev qtbase5-private-dev qtkeychain-qt5-dev qtmultimedia5-dev qtpositioning5-dev qttools5-dev qttools5-dev-tools sip-tools spawn-fcgi xauth xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable xvfb \
    sip-dev

# PgAdmin
sudo apt install -y \
    pgadmin4 \
    libpq-dev libpqxx-dev # libraries

# Samba
sudo apt-get -y install samba 
sudo usermod -aG sambashare $USER

# VirtualBox
sudo apt-get install -y virtualbox

# R packages
Rscript install_packages.R

# VCPKG
cd ~
git clone https://github.com/microsoft/vcpkg.git
echo "VCPKG_ROOT=~/vcpkg" | sudo tee -a /etc/environment
$VCPKG_ROOT/bootstrap-vcpkg.sh
