# Jellyfin data migration to persistent location

BACKUP_DIR=

/usr/bin/rsync -av --delete /var/lib/jellyfin/ $BACKUP_DIR/jellyfin/var/
/usr/bin/rsync -av --delete /etc/jellyfin/ $BACKUP_DIR/jellyfin/etc/ 

sudo chown -R jellyfin:jellyfin $BACKUP_DIR/jellyfin

# enable EnvironmentFile
/etc/systemd/system/jellyfin.service.d/jellyfin.service.conf

# change directories
sudo nano /etc/default/jellyfin

sudo rm -rf /var/lib/jellyfin
sudo rm -rf /etc/jellyfin