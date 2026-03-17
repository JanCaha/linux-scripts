#!/bin/bash
set -euo pipefail

START_DIR="$(pwd)"

# DBeaver
cd /tmp

LATEST_VERSION=$(gh release view --repo dbeaver/dbeaver --json tagName --jq .tagName 2>/dev/null || echo "")

CURRENT_VERSION=""
if command -v dbeaver >/dev/null 2>&1; then
	CURRENT_VERSION=$(dbeaver --version 2>/dev/null | sed -nE 's/^[^0-9]*(([0-9]+\.){2}[0-9]+)(\.[0-9]+)*$/\1/p' || echo "")
fi

if [[ -n "$LATEST_VERSION" && -n "$CURRENT_VERSION" && "$LATEST_VERSION" == "$CURRENT_VERSION" ]]; then
	echo "DBeaver is already up-to-date: $CURRENT_VERSION"
else
	echo "Updating DBeaver from version $CURRENT_VERSION to $LATEST_VERSION"
	
	gh release download --repo dbeaver/dbeaver --pattern "*.deb" --clobber

	sudo apt install "./$(ls dbeaver-ce*x86_64.deb)"

	rm dbeaver-ce*.deb
fi

cd "$START_DIR"