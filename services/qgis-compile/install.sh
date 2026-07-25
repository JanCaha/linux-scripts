#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo cp "$SCRIPT_DIR/qgis-compile.sh" /usr/local/bin/qgis-compile.sh
sudo chmod +x /usr/local/bin/qgis-compile.sh

sudo cp "$SCRIPT_DIR/qgis-compile.service" /etc/systemd/system/qgis-compile.service
sudo cp "$SCRIPT_DIR/qgis-compile.timer" /etc/systemd/system/qgis-compile.timer

sudo systemctl daemon-reload
sudo systemctl enable --now qgis-compile.timer

systemctl list-timers qgis-compile.timer
