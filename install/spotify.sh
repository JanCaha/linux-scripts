#!/bin/bash
set -euo pipefail

# Spotify
# Spotify's own pubkey_*.gpg download URLs have repeatedly pointed to expired
# keys, so fetch the current signing key from a keyserver by fingerprint instead.
sudo install -m 0755 -d /etc/apt/keyrings
gpg --no-default-keyring --keyring /tmp/spotify-keyring.gpg --keyserver keyserver.ubuntu.com --recv-keys E1096BCBFF6D418796DE78515384CE82BA52C83A
sudo gpg --no-default-keyring --keyring /tmp/spotify-keyring.gpg --export --output /etc/apt/keyrings/spotify.gpg
rm -f /tmp/spotify-keyring.gpg /tmp/spotify-keyring.gpg~
echo "deb [signed-by=/etc/apt/keyrings/spotify.gpg] https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install -y spotify-client
