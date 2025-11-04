# Jellyfin data migration to persistent location

```bash
BACKUP_DIR=$BACKUP_DIR_PROFILE

/usr/bin/rsync -av --delete /var/lib/jellyfin/ $BACKUP_DIR/jellyfin/var/
/usr/bin/rsync -av --delete /etc/jellyfin/ $BACKUP_DIR/jellyfin/etc/ 

sudo chown -R jellyfin:jellyfin $BACKUP_DIR/jellyfin
```

## enable EnvironmentFile

```bash
sudo nano /etc/systemd/system/jellyfin.service.d/jellyfin.service.conf
```

## change directories

```bash
sudo nano /etc/default/jellyfin
```

## delete folders

```bash
sudo rm -rf /var/lib/jellyfin
sudo rm -rf /etc/jellyfin
```