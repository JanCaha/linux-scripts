#!/bin/bash

# install required libs
sudo apt install cinnamon-desktop-environment xrdp

# change session
echo "exec cinnamon-session" > ~/.xsession
chmod +x ~/.xsession

echo "exec cinnamon-session" > ~/.xinitrc
chmod +x ~/.xinitrc

# remove settings file and replace with cinnamon settings
FILE=/etc/xrdp/startwm.sh
sudo rm $FILE
touch $FILE

echo "unset DBUS_SESSION_BUS_ADDRESS" | sudo tee -a $FILE
echo "unset XDG_RUNTIME_DIR" | sudo tee -a $FILE
echo "exec cinnamon-session" | sudo tee -a $FILE

# restart xrdp
sudo systemctl restart xrdp
