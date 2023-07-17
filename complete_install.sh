#!/bin/zsh
source /etc/os-release

KEYS_FOLDER=/usr/share/keyrings
SOURCES_FOLDER=/etc/apt/sources.list.d

QGIS_UNSTABLE=false

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
KEYRING=$KEYS_FOLDER/git-archive-keyring.gpg
SOURCEFILE=$SOURCES_FOLDER/git.sources
FINGERPRINT=E1DD270288B4E6030699E45FA1715D88E1DF1F24
URL=https://ppa.launchpadcontent.net/git-core/ppa/ubuntu

create_ppa_source.py $KEYRING $FINGERPRINT $SOURCEFILE $URL --add-src

sudo apt update
sudo apt upgrade -y
sudo apt-get -y install git

# Docker
KEYRING=$KEYS_FOLDER/docker-archive-keyring.asc
download_keyfile.py $KEYRING https://download.docker.com/linux/ubuntu/gpg curl

create_source_file.py $KEYRING $SOURCES_FOLDER/docker.sources "https://download.docker.com/linux/ubuntu"  --component "stable"

sudo apt-get update
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin \
    docker-compose

sudo groupadd docker
sudo usermod -aG docker $USER

# VS code
KEYRING=$KEYS_FOLDER/vscode.asc
FILE=$SOURCES_FOLDER/vs-code.sources

download_keyfile.py $KEYRING https://packages.microsoft.com/keys/microsoft.asc wget

create_source_file.py $KEYRING $FILE http://packages.microsoft.com/repos/code  --component "main" --distro_code_name stable


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
	
# GIS
KEYRING=$KEYS_FOLDER/ubuntugis-archive-keyring.gpg
SOURCEFILE=$SOURCES_FOLDER/ubuntugis-stable.sources
FINGERPRINT=6B827C12C2D425E227EDCA75089EBE08314DF160
URL=https://ppa.launchpadcontent.net/ubuntugis/ppa/ubuntu

create_ppa_source.py $KEYRING $FINGERPRINT $SOURCEFILE $URL --add-src


if [ "$QGIS_UNSTABLE" = "true" ]; then
    echo "Using QGIS Unstable GIS!!!!!!!!!!!"
    ## GIS unstable
    KEYRING=$KEYS_FOLDER/ubuntugis-archive-keyring.gpg
    SOURCEFILE=$SOURCES_FOLDER/ubuntugis-unstable.sources
    FINGERPRINT=6B827C12C2D425E227EDCA75089EBE08314DF160
    URL=https://ppa.launchpadcontent.net/ubuntugis/ubuntugis-unstable/ubuntu

    create_ppa_source.py $KEYRING $FINGERPRINT $SOURCEFILE $URL --add-src
fi

# QGIS
if [ "$QGIS_UNSTABLE" = "true" ]; then
    URL=https://qgis.org/ubuntugis
else
    URL=https://qgis.org/ubuntu
fi

KEYRING=$KEYS_FOLDER/qgis-archive-keyring.gpg
SOURCEFILE=$SOURCES_FOLDER/qgis.sources

download_keyfile.py $KEYRING https://download.qgis.org/downloads/qgis-archive-keyring.gpg wget

create_source_file.py $KEYRING $SOURCEFILE $URL --add-src

sudo apt update
sudo apt upgrade -y
sudo apt-get install -y \
    qgis \
    libqgis-dev

# TinyTeX
# wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh

# R
KEYRING=$KEYS_FOLDER/r-archive-keyring.asc
SOURCEFILE=$SOURCES_FOLDER/r.list
FINGERPRINT=6B827C12C2D425E227EDCA75089EBE08314DF160
URL=https://cloud.r-project.org/bin/linux/ubuntu

download_keyfile.py $KEYRING https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc wget
# create_source_file.py $KEYRING $SOURCEFILE $URL --add-src --distro_code_name jammy-cran40 --component /

echo "deb [signed-by=$KEYRING arch=amd64] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | sudo tee $SOURCEFILE

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
KEYRING=$KEYS_FOLDER/texstudio-archive-keyring.gpg
SOURCEFILE=$SOURCES_FOLDER/texstudio.sources
FINGERPRINT=F4BB443370868B62A293947EB896ADA57C387DD3
URL=https://ppa.launchpadcontent.net/sunderme/texstudio/ubuntu/

create_ppa_source.py $KEYRING $FINGERPRINT $SOURCEFILE $URL true

sudo apt-get update
sudo apt-get install -y texstudio

# Joplin
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash

# Strawbery
KEYRING=$KEYS_FOLDER/strawberry-archive-keyring.gpg
SOURCEFILE=$SOURCES_FOLDER/strawberry.sources
FINGERPRINT=BE5ED0F9261CAAD9A1E5B1A4CD6289E999EA819D
URL=https://ppa.launchpadcontent.net/jonaski/strawberry/ubuntu

create_ppa_source.py $KEYRING $FINGERPRINT $SOURCEFILE $URL --add-src 

# Brave
sudo curl -fsSLo $KEYS_FOLDER/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=$KEYS_FOLDER/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee $SOURCES_FOLDER/brave-browser-release.list

sudo apt-get update

sudo apt-get install -y brave-browser

# WEBP PEEK
KEYRING=$KEYS_FOLDER/peek-archive-keyring.gpg
SOURCEFILE=$SOURCES_FOLDER/peek.sources
FINGERPRINT=8C9531299E7DF2DCF681B4999578539176BAFBC6
URL=https://ppa.launchpadcontent.net/peek-developers/stable/ubuntu

create_ppa_source.py $KEYRING $FINGERPRINT $SOURCEFILE $URL --add-src 

sudo apt update
sudo apt install -y \
    peek

# GitHub CLI
KEYRING=$KEYS_FOLDER/githubcli-archive-keyring.gpg
SOURCEFILE=$SOURCES_FOLDER/github-cli.sources

download_keyfile.py $KEYRING https://cli.github.com/packages/githubcli-archive-keyring.gpg curl
create_source_file.py $KEYRING $SOURCEFILE https://cli.github.com/packages --distro_code_name stable

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
KEYRING=$KEYS_FOLDER/strawberry-archive-keyring.gpg
SOURCEFILE=$SOURCES_FOLDER/strawberry.sources
FINGERPRINT=BE5ED0F9261CAAD9A1E5B1A4CD6289E999EA819D
URL=https://ppa.launchpadcontent.net/jonaski/strawberry/ubuntu

create_ppa_source.py $KEYRING $FINGERPRINT $SOURCEFILE $URL --add-src
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
KEYRING=$KEYS_FOLDER/kitware.asc
FILE=$SOURCES_FOLDER/cmake.sources
URL=https://apt.kitware.com/ubuntu/

download_keyfile.py $KEYRING https://apt.kitware.com/keys/kitware-archive-latest.asc wget

create_source_file.py $KEYRING $FILE $URL --component main

sudo apt-get update
sudo apt-get install -y cmake

# Rust, Cargo and packages
sudo apt install cargo
cargo install sd
export PATH=~/.cargo/bin:$PATH