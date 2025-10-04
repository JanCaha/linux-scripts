#!/bin/zsh
# needs QuartoVersion, OneDriveLastInstalledHash, RStudioVersion, CalibreVersion in $VariablesFile file

# COLORS
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PINK="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
NORMAL="\033[0;39m"

cd "$(dirname "$0")"

# setup variables
HomeFolder=~
VariablesFile=$HomeFolder/.install_env_variables
currentDir=$(pwd)
R_LIBS_USER=$HOME/R/x86_64-pc-linux-gnu-library/4.3
BASEDIR=$(dirname "$(readlink -f "$0")")

source $currentDir/update_and_upgrade.sh

echo "***"
echo $YELLOW $currentDir $NORMAL
echo "***"

echo "***"
if [[ -f "$VariablesFile" ]]; then
    echo -e "$GREEN $VariablesFile exists. $NORMAL"
else
    echo -e "$RED $VariablesFile does not exist. $NORMAL"
    touch $VariablesFile
    echo "QuartoVersion=''" >>$VariablesFile
    echo "OneDriveLastInstalledHash=''" >>$VariablesFile
    echo "RStudioVersion='v'" >>$VariablesFile
    echo "FreeFileSyncLastVersion='v'" >>$VariablesFile
    echo "KrusaderLastInstalledHash='v'" >>$VariablesFile
    echo "CalibreVersion=''" >>$VariablesFile
    echo "XnViewVersion=''" >>$VariablesFile
    echo "DLangVersion=''" >>$VariablesFile
    echo "DBeaverVersion=''" >>$VariablesFile
fi
echo "***"

source $VariablesFile

# # omz update
# echo -e "$YELLOW---omz update---$NORMAL"
# omz update
# echo -e "$YELLOW---end apt update---$NORMAL"
# echo ""

# R packages updates
echo -e "$YELLOW---R packages update---$NORMAL"
Rscript -e "Sys.getenv('R_LIBS_USER')"
Rscript -e ".libPaths()"
Rscript -e "update.packages(lib.loc = Sys.getenv('R_LIBS_USER'), ask=FALSE)"
echo -e "$YELLOW---end R packages update---$NORMAL"
echo ""

# conda update
echo -e "$YELLOW---conda update---$NORMAL"
micromamba self-update
echo -e "$YELLOW---end conda update---$NORMAL"
echo ""

# move to tmp dir
cd /tmp

# joplin update
echo -e "$YELLOW---Joplin update---$NORMAL"
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
echo -e "$YELLOW---end Joplin update---$NORMAL"
echo ""

# quarto check and update
echo -e "$YELLOW---Quarto update---$NORMAL"
cd /tmp
$currentDir/python/download_quarto.py
echo -e "$YELLOW---end Quarto update---$NORMAL"
echo ""

# onedrive check and update
echo -e "$YELLOW---OneDrive update---$NORMAL"
echo -e "$BLUE---$(onedrive --version)---$NORMAL"
# currentHash="$(git rev-parse HEAD)"
currentHash="$(git ls-remote https://github.com/abraunegg/onedrive.git master | grep -i -E '[a-z|0-9]+' -o -m 1 | head -1)"

if [[ -z "$OneDriveLastInstalledHash" ]]; then
    OneDriveLastInstalledHash=""
fi

if [ "$currentHash" != "$OneDriveLastInstalledHash" ]; then
    source $BASEDIR/install/onedrive.sh
    sed -i "s/^OneDriveLastInstalledHash=.*/OneDriveLastInstalledHash='$currentHash'/g" $VariablesFile
else
    echo -e "$PINK Skipping OneDrive Update $NORMAL"
fi

cd .. && rm -rf onedrive
echo -e "$YELLOW---end OneDrive update---$NORMAL"
echo ""

# RStudio
echo -e "$YELLOW---RStudio update---$NORMAL"
cd /tmp
$currentDir/python/download_RStudio.py
echo -e "$YELLOW---end RStudio update---$NORMAL"
echo ""

# XnView
echo -e "$YELLOW---XnView update---$NORMAL"
cd /tmp
$currentDir/python/download_XnView.py
echo -e "$YELLOW---end XnView update---$NORMAL"
echo ""

# # FreeFileSync
# echo -e "$YELLOW---FreeFileSync update---$NORMAL"
# cd /tmp
# #$currentDir/python/download_FreeFileSync.py
# echo -e "$YELLOW---end FreeFileSync update---$NORMAL"
# echo ""

# Calibre
echo -e "$YELLOW---Calibre update---$NORMAL"

version=$(python3 $currentDir/python/check_calibre_version.py)
if [ -z "$version"]; then
    echo -e "$PINK Version found online $version matches currently installed. $NORMAL"
    echo -e "$PINK Skipping Calibre Update $NORMAL"
else
    sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
    sed -i "s/^CalibreVersion=.*/CalibreVersion='$version'/g" $VariablesFile
fi

echo -e "$YELLOW---end Calibre update---$NORMAL"
echo ""

# # krusader check and update
# echo -e "$YELLOW---Krusader update---$NORMAL"
# echo -e "$BLUE---$(krusader --version)---$NORMAL"
# #currentHash="$(git rev-parse HEAD)"
# currentHash="$(git ls-remote https://invent.kde.org/utilities/krusader master | grep -i -E '[a-z|0-9]+' -o -m 1 | head -1)"

# if [[ -z "$KrusaderLastInstalledHash" ]]; then
# KrusaderLastInstalledHash=""
# fi

# if [ "$currentHash" != "$KrusaderLastInstalledHash" ];
# then
#     cd /tmp
#     git clone https://invent.kde.org/utilities/krusader
#     cd krusader
#     cmake -DCMAKE_INSTALL_PREFIX=/usr/ -DCMAKE_C_FLAGS="-O2 -fPIC" -DCMAKE_CXX_FLAGS="-O2 -fPIC"
#     sudo make install
#     sed -i "s/^KrusaderLastInstalledHash=.*/KrusaderLastInstalledHash='$currentHash'/g" $VariablesFile
# else
#     echo -e "$PINK Skipping Krusader Update $NORMAL"
# fi

# cd .. && sudo rm -rf krusader
# echo -e "$YELLOW---end Krusader update---$NORMAL"
# echo ""

# DBeaver check and update
echo -e "$YELLOW---DBeaver update---$NORMAL"

CURRENT_RELEASE=$(gh release view --repo dbeaver/dbeaver --json tagName --jq .tagName)

if [[ -z "$DBeaverVersion" ]]; then
    DBeaverVersion=""
fi

if [ "$CURRENT_RELEASE" != "$DBeaverVersion" ]; then
    source $currentDir/install/dbeaver.sh
fi

echo -e "$YELLOW---end DBeaver update---$NORMAL"
echo ""

# wait at the end
# read -p "Press any key to resume ..."
echo 'Press any key to continue...'
read -k1 -s