#! /bin/bash
# get current script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# this creates symbolic from pg-docker.desktopt to $HOME/.local/share/applications
LAUNCHER_PATH="$HOME/.local/share/applications"

ln -s "$SCRIPT_DIR/pg-docker.desktop" "$LAUNCHER_PATH/pg-docker.desktop"
ln -s "$SCRIPT_DIR/reboot-to-win.desktop" "$LAUNCHER_PATH/reboot-to-win.desktop"
ln -s "$SCRIPT_DIR/update-upgrade.desktop" "$LAUNCHER_PATH/update-upgrade.desktop"
ln -s "$SCRIPT_DIR/connect-to-pc.desktop" "$LAUNCHER_PATH/connect-to-pc.desktop"
ln -s "$SCRIPT_DIR/qgis-dev.desktop" "$LAUNCHER_PATH/qgis-dev.desktop"