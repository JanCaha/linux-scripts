#!/bin/bash
set -euo pipefail

# Calibre
sudo apt-get install -y libxcb-cursor0
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin