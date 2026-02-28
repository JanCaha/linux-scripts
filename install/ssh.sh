sudo apt update
sudo apt install openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

sudo ufw allow ssh