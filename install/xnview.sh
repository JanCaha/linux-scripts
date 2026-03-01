#!/bin/bash
set -euo pipefail

START_DIR="$(pwd)"

cd /tmp

wget -O XnViewMP-linux-x64.deb "https://www.xnview.com/download.php?update=1&file=XnViewMP-linux-x64.deb"

sudo apt install "./XnViewMP-linux-x64.deb"

cd "$START_DIR"
