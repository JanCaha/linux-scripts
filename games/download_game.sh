#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

usage() {
    cat <<EOF
Usage:
  $0 <game-name> <download-url> [target-dir] [site-name]

Examples:
  $0 dune2 "https://archive.org/download/example/dune2.zip" "$HOME/Games/dosbox/games/dune2" archive.org
  $0 galaga "https://example.com/galaga.zip" "$HOME/Games/mame/roms/galaga" mame

Supported site names:
  archive.org, archive, mame, emuparadise
EOF
}

if [[ $# -lt 2 ]]; then
    usage
    exit 1
fi

GAME_NAME="$1"
DOWNLOAD_URL="$2"
TARGET_DIR="${3:-$DOWNLOADS_DIR/$GAME_NAME}"
SITE_NAME="${4:-archive.org}"

print_header "Downloading $GAME_NAME from $SITE_NAME"

ensure_dir "$TARGET_DIR"

ARCHIVE_PATH="$TARGET_DIR/source.zip"
wget -O "$ARCHIVE_PATH" "$DOWNLOAD_URL"

mkdir -p "$TARGET_DIR/extracted"

if command -v 7z >/dev/null 2>&1; then
    7z x -o"$TARGET_DIR/extracted" -y "$ARCHIVE_PATH" >/dev/null || true
else
    unzip -o "$ARCHIVE_PATH" -d "$TARGET_DIR/extracted"
fi

# If the downloaded archive contains a single nested folder, flatten it.
if [[ -d "$TARGET_DIR/extracted" ]]; then
    nested_count=$(find "$TARGET_DIR/extracted" -mindepth 1 -maxdepth 1 | wc -l)
    if [[ "$nested_count" -eq 1 ]]; then
        nested_dir=$(find "$TARGET_DIR/extracted" -mindepth 1 -maxdepth 1 -type d | head -n 1)
        if [[ -n "$nested_dir" ]] && [[ "$nested_dir" != "$TARGET_DIR/extracted" ]]; then
            find "$nested_dir" -mindepth 1 -maxdepth 1 -exec mv -t "$TARGET_DIR" {} +
        fi
    fi
fi

cat <<EOF
Download complete.
- Game: $GAME_NAME
- Site: $SITE_NAME
- Archive: $ARCHIVE_PATH
- Destination: $TARGET_DIR
EOF
