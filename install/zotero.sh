#!/bin/zsh
URL="https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64"

VERSION_URL=$(curl -ILs $URL | grep -i ^location | sed 's/^location: //i')
VERSION=$(echo $VERSION_URL | grep -oP '(?<=release/)[^/]+')

INSTALLED_VERSION=$(grep -i ^ZoteroVersion= $HOME/.install_env_variables |  grep -oP '\d+\.\d+\.\d+')

if [ "$VERSION" != "$INSTALLED_VERSION" ]; then
    echo -e "$YELLOW Zotero $VERSION is available. $NORMAL"
    echo -e "$YELLOW Installing Zotero $VERSION. $NORMAL"
    
    cd /tmp
    wget -q $URL -O zotero.tar.bz2
    rm -rf $HOME/Applications/Zotero_linux-x86_64
    tar -xjf zotero.tar.bz2 -C $HOME/Applications

    sed -i "s/^ZoteroVersion=.*/ZoteroVersion='$VERSION'/g" $HOME/.install_env_variables
else
    echo -e "$PINK Zotero $VERSION is already installed. $NORMAL"
fi