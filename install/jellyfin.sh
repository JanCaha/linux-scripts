# Jellyfin
sudo apt-get install -y jellyfin-server jellyfin-web jellyfin-ffmpeg6

sudo systemctl stop jellyfin

sudo rm -rf /var/lib/jellyfin
sudo rm -rf /etc/jellyfin

BACKUP_DIR=/home/cahik/Disc-Seagate/Backup

if [ -d "$BACKUP_DIR/jellyfin" ]; then
    sudo mkdir -p /var/lib/jellyfin
    sudo mkdir -p /etc/jellyfin
    sudo cp -r $BACKUP_DIR/jellyfin/var/ /var/lib/jellyfin/
    sudo cp -r $BACKUP_DIR/jellyfin/etc/ /etc/jellyfin/
fi

sudo systemctl start jellyfin

sudo usermod -aG $USER jellyfin


sudo sqlite3  $HOME/Backup/Jellyfin/var/data/jellyfin.db

## SELECT Path FROM BaseItems WHERE Path LIKE '/Old/Path/%';

UPDATE BaseItems
SET Path = REPLACE(Path, '/Old/Path/', '/New/Path/')
WHERE Path LIKE '/Old/Path/%';

.exit