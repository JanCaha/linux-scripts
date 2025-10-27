sudo apt install x11vnc -y
x11vnc -storepasswd


ps -ef | grep -E 'X|Xorg'

sudo cp x11vnc.service /etc/systemd/system/x11vnc.service

sudo systemctl daemon-reload
sudo systemctl enable x11vnc.service
sudo systemctl start x11vnc.service