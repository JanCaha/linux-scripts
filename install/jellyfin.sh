# Jellyfin
sudo apt-get install -y jellyfin-server jellyfin-web jellyfin-ffmpeg6

sudo ufw allow jellyfin
sudo ufw reload

sudo usermod -aG $USER jellyfin

sudo systemctl stop jellyfin

sudo sqlite3  $HOME/Backup/Jellyfin/var/data/jellyfin.db

## SELECT Path FROM BaseItems WHERE Path LIKE '/Old/Path/%';

UPDATE BaseItems
SET Path = REPLACE(Path, '/Old/Path/', '/New/Path/')
WHERE Path LIKE '/Old/Path/%';

.exit

sudo systemctl start jellyfin
