#!/bin/bash

echo "🚀 Installing  Mame + DosBOX"

# Wine
sudo apt-get install -y --install-recommends winehq-stable

# Dosbox and Mame
sudo apt install -y \
    mame \
    dosbox

echo "✅ Mame + DosBOX installed"