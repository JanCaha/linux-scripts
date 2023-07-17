#!/bin/zsh
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
    ksnip

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
    libpqxx-dev

# Fd - find replacement
sudo apt-get install -y fd-find
ln -s $(which fdfind) ~/.local/bin/fd

# redshift
sudo apt-get remove redshift-gtk
rm ~/.config/redshift.conf
sudo apt-get install redshift

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

# TinyTeX
# wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh

# R
sudo apt-get update -y
sudo apt-get install -y \
    r-base \
    r-base-dev

sudo apt install -y \
	libudunits2-dev \
	gdal-bin \
	libgdal-dev \
	libgit2-dev \
	libharfbuzz-dev \
	libfribidi-dev \
	libssh-dev \
	qpdf

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
sudo ./Miniconda3-latest-Linux-x86_64.sh -b -f -p ~$USER/miniconda3

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
sudo apt-get install -y nodejs

# CMake
sudo apt-get update
sudo apt-get install -y cmake

# Rust, Cargo and packages
sudo apt install cargo
cargo install sd
export PATH=~/.cargo/bin:$PATH