#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ -f "$ROOT_DIR/settings/.env" ]]; then
    source "$ROOT_DIR/settings/.env"
fi

source "$SCRIPT_DIR/common.sh"

APPS_DIRECTORY="${APPS_DIRECTORY:-$HOME/Apps}"
LAUNCHER_PATH="${LAUNCHER_PATH:-$HOME/.local/share/applications}"
DBGL_INSTALL_DIR="${DBGL_INSTALL_DIR:-$APPS_DIRECTORY/dbgl}"
DBGL_ARCHIVE_PATH="${DBGL_ARCHIVE_PATH:-$DOWNLOADS_DIR/dbgl.tar.xz}"

print_header "Installing emulator dependencies"

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    default-jre \
    dosbox \
    mame \
    unzip \
    wget \
    p7zip-full \
    git \
    build-essential \
    cmake \
    libasound2-dev \
    libgl1-mesa-dev \
    libsfml-dev \
    libfreeimage-dev \
    libfreetype6-dev \
    libcurl4-openssl-dev \
    libvlc-dev \
    libx11-dev \
    libsdl2-dev \
    pkg-config

if ! command -v emulationstation >/dev/null 2>&1; then
    cd /tmp
    git clone --depth 1 https://github.com/RetroPie/EmulationStation.git emulationstation-src
    cd emulationstation-src
    cmake .
    make -j"$(nproc)"
    sudo make install
fi

ensure_dir "$GAMES_ROOT"
ensure_dir "$MAME_ROMS_DIR"
ensure_dir "$MAME_ARTWORK_DIR"
ensure_dir "$MAME_SAMPLES_DIR"
ensure_dir "$DOSBOX_GAMES_DIR"
ensure_dir "$DOSBOX_CONFIG_DIR"
ensure_dir "$DOWNLOADS_DIR"
ensure_dir "$APPS_DIRECTORY"

print_header "Installing DBGL"

wget -O "$DBGL_ARCHIVE_PATH" "https://dbgl.org/download/dbgl099.tar.xz"
mkdir -p "$DBGL_INSTALL_DIR"
tar -xJf "$DBGL_ARCHIVE_PATH" -C "$DBGL_INSTALL_DIR"

DBGL_ICON=""
if [[ -f "$DBGL_INSTALL_DIR/dbgl.png" ]]; then
    DBGL_ICON="$DBGL_INSTALL_DIR/dbgl.png"
elif [[ -f "$DBGL_INSTALL_DIR/resources/icon.png" ]]; then
    DBGL_ICON="$DBGL_INSTALL_DIR/resources/icon.png"
else
    DBGL_ICON="applications-games"
fi

mkdir -p "$LAUNCHER_PATH"
cat > "$LAUNCHER_PATH/dbgl.desktop" <<EOF
[Desktop Entry]
Name=DBGL
Exec=java -jar $DBGL_INSTALL_DIR/dbgl.jar
Comment=DOSBox Game Launcher
Terminal=false
PrefersNonDefaultGPU=false
Icon=$DBGL_ICON
Type=Application
Categories=Game;
EOF

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$LAUNCHER_PATH"
fi

cat <<EOF
Installed software and prepared folders:
- MAME: $MAME_ROOT
- DOSBox: $DOSBOX_ROOT
- ROMs: $MAME_ROMS_DIR
- Artwork: $MAME_ARTWORK_DIR
- DOSBox games: $DOSBOX_GAMES_DIR
- DBGL: $DBGL_INSTALL_DIR
- DBGL launcher: $LAUNCHER_PATH/dbgl.desktop
- DBGL icon: $DBGL_ICON
EOF
