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