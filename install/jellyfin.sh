# Jellyfin
sudo apt-get install -y jellyfin-server jellyfin-web jellyfin-ffmpeg6 

sudo ln -s $HOME/Documents/jellyfin/var /var/lib/jellyfin
# sudo ln -s $HOME/Documents/jellyfin/etc/jellyfin /etc/jellyfin
sudo chown -R jellyfin $HOME/Documents/jellyfin

# sudo iptables -A INPUT -p tcp --dport 8096 -j ACCEPT

#sudo rm -rf /var/lib/jellyfin
sudo cp -r /var/lib/jellyfin $HOME/Documents/jellyfin