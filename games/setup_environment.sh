#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_header() {
    echo
    echo "==== $1 ===="
}

print_header "Setting up game emulators"

"$SCRIPT_DIR/install_emulators.sh"
"$SCRIPT_DIR/configure_mame.sh"
"$SCRIPT_DIR/configure_dosbox.sh" "$HOME/Games/dosbox/games" "default"

cat <<EOF
Environment is ready.

Use these paths for your games:
- MAME ROMs: $HOME/Games/mame/roms
- DOSBox games: $HOME/Games/dosbox/games
- Downloads: $HOME/Games/downloads

Examples:
  $SCRIPT_DIR/configure_dosbox.sh "$HOME/Games/dosbox/games/doom" "doom"
  $SCRIPT_DIR/download_game.sh dune2 "https://example.com/dune2.zip" "$HOME/Games/dosbox/games/dune2" archive.org
EOF
