#!/bin/bash
set -euo pipefail

# Jellyfin Desktop (formerly Jellyfin Media Player) - built from source
# v2.0.0 has no Linux binaries on GitHub releases, so build it against system libmpv/mpvqt
JELLYFIN_DESKTOP_VERSION="v2.0.0"

sudo apt-get install -y \
    build-essential \
    cmake \
    git \
    ninja-build \
    pkg-config \
    python3 \
    libmpv-dev \
    libmpvqt-dev \
    libcec-dev \
    libsdl2-dev \
    libx11-dev \
    libxrandr-dev \
    libgl1-mesa-dev \
    libegl1-mesa-dev \
    qt6-base-dev \
    qt6-base-private-dev \
    qt6-declarative-dev \
    qt6-webengine-dev \
    qt6-webengine-private-dev \
    qt6-wayland-dev \
    qml6-module-qtqml-workerscript \
    qml6-module-qtquick-controls \
    qml6-module-qtquick-templates \
    qml6-module-qtquick-window \
    qml6-module-qtwebchannel \
    qml6-module-qtwebengine

BUILD_DIR=$(mktemp -d)
trap 'rm -rf "$BUILD_DIR"' EXIT

git clone --depth 1 --branch "$JELLYFIN_DESKTOP_VERSION" \
    https://github.com/jellyfin/jellyfin-desktop.git "$BUILD_DIR/jellyfin-desktop"

cmake -S "$BUILD_DIR/jellyfin-desktop" -B "$BUILD_DIR/jellyfin-desktop/build" -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local
cmake --build "$BUILD_DIR/jellyfin-desktop/build" -j"$(nproc)"
sudo cmake --install "$BUILD_DIR/jellyfin-desktop/build"
