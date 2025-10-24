ip link show

sudo ethtool eth0

##  need
# Supports Wake-on: pumbg
# Wake-on: d

nmcli connection show
sudo nmcli connection modify "Wired connection 1" 802-3-ethernet.wake-on-lan magic
sudo systemctl restart NetworkManager
sudo ethtool eth0 | grep Wake-on

journalctl -b -1 | grep -i wake
