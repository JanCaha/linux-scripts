#!/bin/bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$BASEDIR/docker_envs.sh"

COMPOSE_FILE="$DOCKER_COMPOSE/jellyfin-media-pc-encrypted.yaml"
MOUNTPOINT_PATH="${JELLYFIN_LUKS_MOUNTPOINT_ENCRYPTED:-$HOME/Disc-Personal}"

if ! mountpoint -q "$MOUNTPOINT_PATH"; then
    echo "LUKS mountpoint is not attached: $MOUNTPOINT_PATH"
    echo "Attempting to unlock and mount the encrypted partition automatically..."

    sudo mkdir -p "$MOUNTPOINT_PATH"

    if [ -b "/dev/mapper/media-pc-luks" ]; then
        echo "Device /dev/mapper/media-pc-luks already exists; mounting it now."
        sudo mount /dev/mapper/media-pc-luks "$MOUNTPOINT_PATH"
    elif [ -b "/dev/sda3" ] && command -v cryptsetup >/dev/null 2>&1 && cryptsetup isLuks /dev/sda3 >/dev/null 2>&1; then
        echo "Opening LUKS volume /dev/sda3 as media-pc-luks"
        sudo cryptsetup open /dev/sda3 media-pc-luks
        echo "Mounting /dev/mapper/media-pc-luks to $MOUNTPOINT_PATH"
        sudo mount /dev/mapper/media-pc-luks "$MOUNTPOINT_PATH"
    else
        echo "Automatic mount failed. Please do this manually first:"
        echo "  sudo cryptsetup open /dev/sda3 media-pc-luks"
        echo "  sudo mkdir -p $MOUNTPOINT_PATH"
        echo "  sudo mount /dev/mapper/media-pc-luks $MOUNTPOINT_PATH"
        exit 1
    fi

    if ! mountpoint -q "$MOUNTPOINT_PATH"; then
        echo "Mount failed even after the unlock step."
        exit 1
    fi
fi

required_paths=(
    "${JELLYFIN_DATA_DIR_ENCRYPTED:-$MOUNTPOINT_PATH/Jellyfin/var}"
    "${JELLYFIN_CONFIG_DIR_ENCRYPTED:-$MOUNTPOINT_PATH/Jellyfin/etc}"
    "${JELLYFIN_CACHE_DIR_ENCRYPTED:-$MOUNTPOINT_PATH/Jellyfin/cache}"
    "${JELLYFIN_MEDIA_DIR_ENCRYPTED:-$MOUNTPOINT_PATH/Media}"
)

for path in "${required_paths[@]}"; do
    if [ ! -d "$path" ]; then
        echo "Required directory does not exist: $path"
        exit 1
    fi
done

export JELLYFIN_DATA_DIR_ENCRYPTED="${JELLYFIN_DATA_DIR_ENCRYPTED:-$MOUNTPOINT_PATH/Jellyfin/var}"
export JELLYFIN_CONFIG_DIR_ENCRYPTED="${JELLYFIN_CONFIG_DIR_ENCRYPTED:-$MOUNTPOINT_PATH/Jellyfin/etc}"
export JELLYFIN_CACHE_DIR_ENCRYPTED="${JELLYFIN_CACHE_DIR_ENCRYPTED:-$MOUNTPOINT_PATH/Jellyfin/cache}"
export JELLYFIN_MEDIA_DIR_ENCRYPTED="${JELLYFIN_MEDIA_DIR_ENCRYPTED:-$MOUNTPOINT_PATH/Media}"

docker compose -f "$COMPOSE_FILE" up -d
