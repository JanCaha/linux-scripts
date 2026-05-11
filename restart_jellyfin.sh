#!/bin/bash

# Mount all filesystems defined in /etc/fstab
sudo mount -a

# Restart the jellyfin container
docker restart jellyfin-machine
