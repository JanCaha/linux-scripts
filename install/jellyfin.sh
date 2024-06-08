# Jellyfin
sudo apt-get install -y jellyfin-server jellyfin-web jellyfin-ffmpeg6 

sudo ln -s $HOME/Documents/jellyfin/var /var/lib/jellyfin
sudo ln -s $HOME/Documents/jellyfin/etc/jellyfin /etc/jellyfin
sudo chown -R jellyfin $HOME/Documents/jellyfin


# sudo iptables -A INPUT -p tcp --dport 8096 -j ACCEPT


# this does not work
# # set data dir

# FILE=/etc/environment
# LINE=$(grep "^JELLYFIN_DATA_DIR=" $FILE)
# MY_LINE="JELLYFIN_DATA_DIR=$HOME/.local/share/jellyfin"

# if [ ! -z "$LINE" ];
# then
#     echo "Jellfin data dir already set."
#      sd -s $LINE $MY_LINE $FILE
# else
#     echo "JELLYFIN_DATA_DIR=$HOME/.local/share/jellyfin" >> $FILE
# fi