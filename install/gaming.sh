#!/bin/bash
set -euo pipefail

echo "🚀 Installing  Mame + DosBOX"

# Wine
sudo apt-get install -y --install-recommends wine

# Dosbox and Mame
sudo apt install -y \
    mame \
    dosbox

echo "✅ Mame + DosBOX installed"

echo "🚀 Installing DBGL"

# DBGL needs a JRE to run
sudo apt install -y default-jre

START_DIR="$(pwd)"

[ -d "$APPS_DIRECTORY" ] || mkdir -p "$APPS_DIRECTORY"

cd /tmp
wget -O dbgl.tar.xz "https://dbgl.org/download/dbgl099.tar.xz"

DBGL_APPS_DIRECTORY="$APPS_DIRECTORY/dbgl"

[ -d "$DBGL_APPS_DIRECTORY" ] || mkdir -p "$DBGL_APPS_DIRECTORY"

echo "📦 Unpacking dbgl.tar.xz to $DBGL_APPS_DIRECTORY"
tar -xJf dbgl.tar.xz -C "$DBGL_APPS_DIRECTORY"

cd "$START_DIR"

echo "✅ DBGL installed"
