#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

SRC_ZSHRC="$SCRIPT_DIR/.zshrc"
SRC_ZSHENV="$SCRIPT_DIR/.zshenv"
SRC_ZPROFILE="$SCRIPT_DIR/.zprofile"

for file in "$SRC_ZSHRC" "$SRC_ZSHENV" "$SRC_ZPROFILE"; do
    if [ ! -f "$file" ]; then
        echo "Missing required file: $file" >&2
        exit 1
    fi
done

# git-crypt encrypted blobs contain a GITCRYPT header. Refuse to copy a locked file.
if grep -aq "GITCRYPT" "$SRC_ZSHENV"; then
    echo "Detected encrypted content in $SRC_ZSHENV. Unlock the repository before copying." >&2
    exit 1
fi

echo "Copying files .zshenv, .zshrc, .zprofile from $SCRIPT_DIR to $HOME"

install -m 0644 "$SRC_ZSHRC" "$HOME/.zshrc"
install -m 0600 "$SRC_ZSHENV" "$HOME/.zshenv"
install -m 0644 "$SRC_ZPROFILE" "$HOME/.zprofile"

echo "Done copying zsh configuration files."
