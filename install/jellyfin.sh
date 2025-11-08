# Jellyfin
sudo apt-get install -y jellyfin-server jellyfin-web jellyfin-ffmpeg6

sudo ufw allow jellyfin
sudo ufw reload

sudo usermod -aG $USER jellyfin

sudo systemctl stop jellyfin

DB="$HOME/Backup/Jellyfin/var/data/jellyfin.db"
OLD="/Old/Path/"
NEW="/New/Path/"

# Optional: preview first 5 paths to be changed
sudo -u jellyfin sqlite3 "$DB" "SELECT Path FROM BaseItems WHERE Path LIKE '${OLD}%' LIMIT 5;"

# Apply update inside a transaction and report number of rows changed
sudo -u jellyfin sqlite3 "$DB" <<SQL
PRAGMA foreign_keys=ON;
BEGIN;
UPDATE BaseItems
  SET Path = REPLACE(Path, '$OLD', '$NEW')
  WHERE Path LIKE '${OLD}%';
SELECT changes() AS rows_updated;
COMMIT;
SQL


sudo systemctl start jellyfin
