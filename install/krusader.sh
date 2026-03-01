#!/bin/bash
set -euo pipefail

START_DIR="$(pwd)"

sudo apt-get install extra-cmake-modules

sudo apt-get install -y nemo cinnamon-control-center xdg-utils 

# KF6 dependencies
sudo apt-get install -y \
    extra-cmake-modules \
    libkf6archive-dev \
    libkf6bookmarks-dev \
    libkf6codecs-dev \
    libkf6completion-dev \
    libkf6coreaddons-dev \
    libkf6config-dev \
    libkf6crash-dev \
    libkf6doctools-dev \
    libkf6globalaccel-dev \
    libkf6i18n-dev \
    libkf6iconthemes-dev \
    libkf6itemviews-dev \
    libkf6kio-dev \
    libkf6notifications-dev \
    libkf6parts-dev \
    libkf6solid-dev \
    libkf6textwidgets-dev \
    libkf6wallet-dev \
    libkf6widgetsaddons-dev \
    libkf6windowsystem-dev \
    libkf6xmlgui-dev \
    libkf6guiaddons-dev \
    libkf6statusnotifieritem-dev \
    libkf6colorscheme-dev

# Install Krusader
cd /tmp
git clone https://invent.kde.org/utilities/krusader
cd krusader
cmake -DCMAKE_INSTALL_PREFIX=/usr/ -DCMAKE_C_FLAGS="-O2 -fPIC" -DCMAKE_CXX_FLAGS="-O2 -fPIC"
sudo make install

sudo apt-get install -y  krusader

cd "$START_DIR"