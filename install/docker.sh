#!/bin/bash
set -euo pipefail

# Install Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

source /etc/os-release
# Docker has no repo for Debian testing/sid; fall back to the latest stable codename it supports.
DOCKER_CODENAME=$VERSION_CODENAME
if [[ "$DOCKER_CODENAME" == "testing" || "$DOCKER_CODENAME" == "sid" || "$DOCKER_CODENAME" == "forky" ]]; then
    DOCKER_CODENAME=trixie
fi

echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $DOCKER_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt update
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

sudo groupadd docker || true
if [[ -n "${USER:-}" ]]; then
    sudo usermod -aG docker $USER
fi
