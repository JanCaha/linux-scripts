#!/bin/bash
set -euo pipefail

START_DIR="$(pwd)"

# DBeaver
cd /tmp

gh release download --repo dbeaver/dbeaver --pattern "*.deb" --clobber

sudo apt install "./$(ls dbeaver-ce*x86_64.deb)"

rm dbeaver-ce_*.deb

cd "$START_DIR"