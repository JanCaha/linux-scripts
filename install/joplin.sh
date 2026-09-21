#!/bin/bash
set -euo pipefail

START_DIR="$(pwd)"

sudo apt-get install libfuse2t64

# Joplin
cd /tmp

wget -O joplin_install.sh https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh

bash joplin_install.sh --allow-root

cd "$START_DIR"