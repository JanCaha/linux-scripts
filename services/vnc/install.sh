#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

sudo apt install x11vnc -y

# ps -ef | grep -E 'X|Xorg'

sudo mkdir -p /root/.vnc
sudo x11vnc -storepasswd /root/.vnc/passwd

sudo cp "$SCRIPT_DIR/x11vnc.service" /etc/systemd/system/x11vnc.service

sudo systemctl daemon-reload
sudo systemctl enable x11vnc.service
sudo systemctl start x11vnc.service
