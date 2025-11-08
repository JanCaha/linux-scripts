# Samba
sudo apt-get -y install samba 
sudo usermod -aG sambashare $USER

sudo nano /etc/samba/smb.conf

## add at the end of the file:
# [shared_folder]
#    comment = Home Media Share Folder
#    path = /Shared_Folder
#    browseable = yes
#    writable = yes
#    read only = no
#    create mask = 0664
#    directory mask = 0775
#    valid users = sambashare

sudo smbpasswd -a sambashare
sudo smbpasswd -e sambashare

sudo systemctl restart smbd nmbd
sudo systemctl enable smbd nmbd

sudo ufw allow samba
sudo ufw reload