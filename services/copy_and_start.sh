#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo cp $SCRIPT_DIR/backup-on-shutdown.service /etc/systemd/system/backup-on-shutdown.service
# sudo systemctl daemon-reload
# sudo systemctl start backup-on-shutdown.service
sudo systemctl enable backup-on-shutdown.service
# sudo systemctl disable backup-on-shutdown.service

# systemctl list-unit-files --type=service
