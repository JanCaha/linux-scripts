#!/bin/bash
source /etc/os-release

echo "Adding sources!"

sudo gpg -k

KEYS_FOLDER=/usr/share/keyrings
SOURCES_FOLDER=/etc/apt/sources.list.d

QGIS_UNSTABLE=true

# GIT
KEYRING=$KEYS_FOLDER/git-archive-keyring.gpg
SOURCEFILE=$SOURCES_FOLDER/git.sources
FINGERPRINT=E1DD270288B4E6030699E45FA1715D88E1DF1F24
URL=https://ppa.launchpadcontent.net/git-core/ppa/ubuntu

create_ppa_source.py $KEYRING $FINGERPRINT $SOURCEFILE $URL --add-src

# Docker
KEYRING=$KEYS_FOLDER/docker-archive-keyring.asc
download_keyfile.py $KEYRING https://download.docker.com/linux/ubuntu/gpg curl

create_source_file.py $KEYRING $SOURCES_FOLDER/docker.sources "https://download.docker.com/linux/ubuntu"  --component "stable"

# # VS code
# KEYRING=$KEYS_FOLDER/vscode.asc
# FILE=$SOURCES_FOLDER/vs-code.sources

# download_keyfile.py $KEYRING https://packages.microsoft.com/keys/microsoft.asc wget

# create_source_file.py $KEYRING $FILE http://packages.microsoft.com/repos/code  --component "main" --distro_code_name stable

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

# R
KEYRING=$KEYS_FOLDER/r-archive-keyring.asc
SOURCEFILE=$SOURCES_FOLDER/r.list
FINGERPRINT=6B827C12C2D425E227EDCA75089EBE08314DF160
URL=https://cloud.r-project.org/bin/linux/ubuntu

download_keyfile.py $KEYRING https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc wget
# create_source_file.py $KEYRING $SOURCEFILE $URL --add-src --distro_code_name jammy-cran40 --component "/"

echo "deb [signed-by=$KEYRING arch=amd64] https://cloud.r-project.org/bin/linux/ubuntu $UBUNTU_CODENAME-cran40/" | sudo tee $SOURCEFILE

# TexStudio
KEYRING=$KEYS_FOLDER/texstudio-archive-keyring.gpg
SOURCEFILE=$SOURCES_FOLDER/texstudio.sources
FINGERPRINT=F4BB443370868B62A293947EB896ADA57C387DD3
URL=https://ppa.launchpadcontent.net/sunderme/texstudio/ubuntu/

create_ppa_source.py $KEYRING $FINGERPRINT $SOURCEFILE $URL

# Strawbery
KEYRING=$KEYS_FOLDER/strawberry-archive-keyring.gpg
SOURCEFILE=$SOURCES_FOLDER/strawberry.sources
FINGERPRINT=BE5ED0F9261CAAD9A1E5B1A4CD6289E999EA819D
URL=https://ppa.launchpadcontent.net/jonaski/strawberry/ubuntu

create_ppa_source.py $KEYRING $FINGERPRINT $SOURCEFILE $URL --add-src

# Brave
sudo curl -fsSLo $KEYS_FOLDER/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=$KEYS_FOLDER/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee $SOURCES_FOLDER/brave-browser-release.list

# WEBP PEEK
KEYRING=$KEYS_FOLDER/peek-archive-keyring.gpg
SOURCEFILE=$SOURCES_FOLDER/peek.sources
FINGERPRINT=8C9531299E7DF2DCF681B4999578539176BAFBC6
URL=https://ppa.launchpadcontent.net/peek-developers/stable/ubuntu

create_ppa_source.py $KEYRING $FINGERPRINT $SOURCEFILE $URL --add-src 

# GitHub CLI
KEYRING=$KEYS_FOLDER/githubcli-archive-keyring.gpg
SOURCEFILE=$SOURCES_FOLDER/github-cli.sources

download_keyfile.py $KEYRING https://cli.github.com/packages/githubcli-archive-keyring.gpg curl
create_source_file.py $KEYRING $SOURCEFILE https://cli.github.com/packages --distro_code_name stable

# CMake
KEYRING=$KEYS_FOLDER/kitware.asc
FILE=$SOURCES_FOLDER/cmake.sources
URL=https://apt.kitware.com/ubuntu/

download_keyfile.py $KEYRING https://apt.kitware.com/keys/kitware-archive-latest.asc wget

create_source_file.py $KEYRING $FILE $URL --component main

# Personal PPA
KEYRING=$KEYS_FOLDER/personal.gpg
SOURCEFILE=$SOURCES_FOLDER/personal.sources
FINGERPRINT=0002254B19F8B3682F060871D3AAC36377A9478A
URL=https://ppa.launchpadcontent.net/jancaha/gis-tools/ubuntu
create_ppa_source.py $KEYRING $FINGERPRINT $SOURCEFILE $URL --add-src 

# PostreSQL
KEYRING=$KEYS_FOLDER/pgadmin-archive-keyring.pub
URL=https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$UBUNTU_CODENAME
FILE=$SOURCES_FOLDER/pgadmin.sources

download_keyfile.py $KEYRING https://www.pgadmin.org/static/packages_pgadmin_org.pub curl

create_source_file.py $KEYRING $FILE $URL --component main --distro_code_name pgadmin4

KEYRING=/usr/share/keyrings/postgresql-archive-keyring.asc
URL=http://apt.postgresql.org/pub/repos/apt
FILE=$SOURCES_FOLDER/pg.sources

download_keyfile.py $KEYRING  https://www.postgresql.org/media/keys/ACCC4CF8.asc curl

create_source_file.py $KEYRING $FILE $URL --distro_code_name "jammy-pgdg"

# Wine
KEYRING=$KEYS_FOLDER/winehq.key
URL=https://dl.winehq.org/wine-builds/ubuntu/
FILE=$SOURCES_FOLDER/wine.sources

download_keyfile.py $KEYRING https://dl.winehq.org/wine-builds/winehq.key wget

create_source_file.py $KEYRING $FILE $URL --architecture "i386"

# LibreOffice PPA
KEYRING=$KEYS_FOLDER/libre-office.gpg
SOURCEFILE=$SOURCES_FOLDER/libre-office.sources
FINGERPRINT=36E81C9267FD1383FCC4490983FBA1751378B444
URL=https://ppa.launchpadcontent.net/libreoffice/ppa/ubuntu
create_ppa_source.py $KEYRING $FINGERPRINT $SOURCEFILE $URL --add-src 

#VirtualBox
KEYRING=$KEYS_FOLDER/virtualbox.key
URL=https://download.virtualbox.org/virtualbox/debian
FILE=$SOURCES_FOLDER/virtualbox.sources

download_keyfile.py $KEYRING https://www.virtualbox.org/download/oracle_vbox_2016.asc wget

create_source_file.py $KEYRING $FILE $URL --component contrib

# Jellyfin
KEYRING=$KEYS_FOLDER/jellyfin-archive-keyring.gpg
URL=https://repo.jellyfin.org/ubuntu
FILE=$SOURCES_FOLDER/jellyfin.sources

curl -fsSL https://repo.jellyfin.org/jellyfin_team.gpg.key | sudo gpg --dearmor -o $KEYRING

create_source_file.py $KEYRING $FILE $URL

# KeepassXC PPA
KEYRING=$KEYS_FOLDER/keepassxc.gpg
SOURCEFILE=$SOURCES_FOLDER/keepassxc.sources
FINGERPRINT=D89C66D0E31FEA2874EBD20561922AB60068FCD6
URL=https://ppa.launchpadcontent.net/phoerious/keepassxc/ubuntu
create_ppa_source.py $KEYRING $FINGERPRINT $SOURCEFILE $URL --add-src 
