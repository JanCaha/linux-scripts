#!/usr/bin/env bash
set -euo pipefail

FONT_SOURCE="$HOME/OneDrive/Fonts/fonts_folder"
FONT_TARGET="$HOME/.local/share/fonts"

if [ ! -d "$FONT_SOURCE" ]; then
    echo "Source font directory not found: $FONT_SOURCE"
    exit 1
fi

mkdir -p "$(dirname "$FONT_TARGET")"

if [ -L "$FONT_TARGET" ] || [ -d "$FONT_TARGET" ]; then
    echo "Existing font path found at $FONT_TARGET"
    read -r -p "Back it up and replace it with the OneDrive font folder? [y/N] " response
    case "$response" in
        [Yy] | [Yy][Ee][Ss])
            tar -czf "$HOME/fonts_backup.tar.gz" -C "$(dirname "$FONT_TARGET")" "$(basename "$FONT_TARGET")" 2>/dev/null || true
            rm -rf "$FONT_TARGET"
            ;;
        *)
            echo "Aborted. No changes made."
            exit 1
            ;;
    esac
fi

ln -s "$FONT_SOURCE" "$FONT_TARGET"
echo "Fonts are now linked from $FONT_SOURCE to $FONT_TARGET"

# Update the font cache system-wide to reflect the changes
sudo fc-cache -v
