#!/usr/bin/bash

sudo apt install pipx

# https://github.com/bulletmark/sleep-inhibitor
pipx install sleep-inhibitor

FILE="$(sleep-inhibitor -P)/plugins/jdownloader-open"
sudo tee "$FILE" > /dev/null <<EOF
pgrep -f 'JDownloader' > /dev/null && exit 254
exit 0
EOF
chmod +x "$FILE"

# add plugin above and configure time 
sudo cp "$(sleep-inhibitor -P)/sleep-inhibitor.conf" /etc

# here edit the path to the program
sudo cp "$(sleep-inhibitor -P)/sleep-inhibitor.service" /etc/systemd/system/

sudo systemctl enable --now sleep-inhibitor
sudo systemctl restart sleep-inhibitor

systemctl status sleep-inhibitor

