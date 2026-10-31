#!/usr/bin/env bash
set -euo pipefail

GAMES_ROOT="${GAMES_ROOT:-$HOME/Games}"
MAME_ROOT="${MAME_ROOT:-$GAMES_ROOT/mame}"
DOSBOX_ROOT="${DOSBOX_ROOT:-$GAMES_ROOT/dosbox}"
MAME_ROMS_DIR="${MAME_ROMS_DIR:-$MAME_ROOT/roms}"
MAME_ARTWORK_DIR="${MAME_ARTWORK_DIR:-$MAME_ROOT/artwork}"
MAME_SAMPLES_DIR="${MAME_SAMPLES_DIR:-$MAME_ROOT/samples}"
MAME_CONFIG_DIR="${MAME_CONFIG_DIR:-$MAME_ROOT/config}"
DOSBOX_GAMES_DIR="${DOSBOX_GAMES_DIR:-$DOSBOX_ROOT/games}"
DOSBOX_CONFIG_DIR="${DOSBOX_CONFIG_DIR:-$DOSBOX_ROOT/config}"
DOWNLOADS_DIR="${DOWNLOADS_DIR:-$GAMES_ROOT/downloads}"

ensure_dir() {
    local path="$1"
    mkdir -p "$path"
}

print_header() {
    echo
    echo "==== $1 ===="
}
