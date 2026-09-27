#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

SRC_ZSHRC="$SCRIPT_DIR/.zshrc"
SRC_ZSHENV="$SCRIPT_DIR/.zshenv"
SRC_ZPROFILE="$SCRIPT_DIR/.zprofile"
SRC_ENV="$SCRIPT_DIR/.env"

for file in "$SRC_ZSHRC" "$SRC_ZSHENV" "$SRC_ZPROFILE" "$SRC_ENV"; do
    if [ ! -f "$file" ]; then
        echo "Missing required file: $file" >&2
        exit 1
    fi
done

# git-crypt encrypted blobs contain a GITCRYPT header. Refuse to copy a locked file.
for file in "$SRC_ZSHENV" "$SRC_ENV"; do
    if grep -aq "GITCRYPT" "$file"; then
        echo "Detected encrypted content in $file. Unlock the repository before copying." >&2
        exit 1
    fi
done

echo "Copying files .env, .zshenv, .zshrc, .zprofile from $SCRIPT_DIR to $HOME"

install -m 0600 "$SRC_ENV" "$HOME/.env"
install -m 0644 "$SRC_ZSHRC" "$HOME/.zshrc"
install -m 0600 "$SRC_ZSHENV" "$HOME/.zshenv"
install -m 0644 "$SRC_ZPROFILE" "$HOME/.zprofile"

ENV_SOURCE_LINE='[ -f "$HOME/.env" ] && . "$HOME/.env"'

if ! grep -qxF "$ENV_SOURCE_LINE" "$HOME/.zshenv"; then
    echo "Adding .env sourcing to $HOME/.zshenv"
    printf '\n# shared environment variables, also sourced by bash\n%s\n' "$ENV_SOURCE_LINE" >>"$HOME/.zshenv"
fi

[ -f "$HOME/.bashrc" ] || : >"$HOME/.bashrc"
if ! grep -qxF "$ENV_SOURCE_LINE" "$HOME/.bashrc"; then
    echo "Adding .env sourcing to $HOME/.bashrc"
    printf '\n# shared environment variables, also sourced by zsh\n%s\n' "$ENV_SOURCE_LINE" >>"$HOME/.bashrc"
fi

echo "Done copying zsh configuration files."
