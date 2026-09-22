#! /bin/bash
set -euo pipefail

# get current script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# this copies .desktop files to $HOME/.local/share/applications, substituting
# __HOME__ and __QGIS_BUILD_DIR__ placeholders with their actual values
LAUNCHER_PATH="$HOME/.local/share/applications"

mkdir -p "$LAUNCHER_PATH"

for desktop_file in "$SCRIPT_DIR"/*.desktop; do
    cp -f "$desktop_file" "$LAUNCHER_PATH/$(basename "$desktop_file")"
    sed -i \
        -e "s|__HOME__|$HOME|g" \
        -e "s|__QGIS_BUILD_DIR__|$QGIS_BUILD_DIR|g" \
        "$LAUNCHER_PATH/$(basename "$desktop_file")"
done

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$LAUNCHER_PATH"
fi
