# export HISTIGNORE='*sudo -S*'
# $ echo "passwd" | sudo -S -k ip link set dev enp2s0 down
$ADDRESS=
sudo ip link set dev enp2s0 down
sudo ip link set enp2s0 address $ADDRESS
sudo ip link set dev enp2s0 up
