#! /bin/bash
set -euo pipefail

# get current script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# this creates symbolic from pg-docker.desktopt to $HOME/.local/share/applications
LAUNCHER_PATH="$HOME/.local/share/applications"

mkdir -p "$LAUNCHER_PATH"

ln -sf "$SCRIPT_DIR/pg-docker.desktop" "$LAUNCHER_PATH/pg-docker.desktop"
ln -sf "$SCRIPT_DIR/reboot-to-win.desktop" "$LAUNCHER_PATH/reboot-to-win.desktop"
ln -sf "$SCRIPT_DIR/update-upgrade.desktop" "$LAUNCHER_PATH/update-upgrade.desktop"
ln -sf "$SCRIPT_DIR/connect-to-pc.desktop" "$LAUNCHER_PATH/connect-to-pc.desktop"
ln -sf "$SCRIPT_DIR/qgis-dev.desktop" "$LAUNCHER_PATH/qgis-dev.desktop"

if command -v update-desktop-database >/dev/null 2>&1; then
	update-desktop-database "$LAUNCHER_PATH"
fi
