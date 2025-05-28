#!/bin/bash

LOGFILE="/var/log/backup_on_shutdown.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "[$TIMESTAMP] Starting backup..." >>"$LOGFILE"

BACKUP_DIR=/home/cahik/Disc-Seagate/Backup

if [ -d "$BACKUP_DIR" ]; then
    /usr/bin/rsync -av --delete /var/lib/jellyfin/ $BACKUP_DIR/jellyfin/var/ >>"$LOGFILE" 2>&1
    /usr/bin/rsync -av --delete /etc/jellyfin/ $BACKUP_DIR/jellyfin/etc/ >>"$LOGFILE" 2>&1
fi
echo "[$TIMESTAMP] Backup completed." >>"$LOGFILE"
