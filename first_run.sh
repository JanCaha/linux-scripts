#!/usr/bin/env bash

# install git
sudo apt-get install -y git

# Scripts
CODES_DIR=~/Codes
CODES_SCRIPTS_DIR=$CODES_DIR/linux-scripts
SCRIPTS_DIR=~/Scripts

mkdir -p $CODES_DIR
cd $CODES_DIR
git clone https://github.com/JanCaha/linux-scripts.git
ln -s $CODES_SCRIPTS_DIR $SCRIPTS_DIR
cd ~

# install zsh
$SCRIPTS_DIR/install/zsh.sh

# settings zshrc
mv ~/.zshrc ~/.zshrc_backup
$SCRIPTS_DIR/settings/copy_zsh_settings.sh

# numlock still on
sudo apt install numlockx -y

if [ ! -d /etc/lightdm/lightdm.conf.d ]; then
    sudo mkdir -p /etc/lightdm/lightdm.conf.d
fi

echo -e "[Seat:*]\ngreeter-setup-script=/usr/bin/numlockx on" | sudo tee /etc/lightdm/lightdm.conf.d/numlock.conf

# default autologin user
read -r -p "Enter default user name for autologin (leave empty to skip): " DEFAULT_USER_NAME

if [ -n "$DEFAULT_USER_NAME" ]; then
    echo -e "[Seat:*]\nautologin-user=$DEFAULT_USER_NAME" | sudo tee /etc/lightdm/lightdm.conf.d/autologin.conf
fi

# remove games
sudo apt purge -y \
    aisleriot \
    gnome-chess \
    gnome-mahjongg \
    gnome-mines \
    gnome-sudoku \
    quadrapassel \
    swell-foop \
    tali \
    five-or-more \
    hitori \
    iagno \
    lightsoff \
    four-in-a-row \
    gnome-robots \
    gnome-klotski \
    gnome-2048 \
    gnome-nibbles \
    gnome-taquin \
    gnome-tetravex
