#!/bin/bash
set -euo pipefail

START_DIR="$(pwd)"

# Quarto
cd /tmp
sudo curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
sudo apt install "./quarto-linux-amd64.deb"

cd "$START_DIR"