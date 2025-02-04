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
./install/zsh.sh

# settings zshrc
mv ~/.zshrc ~/.zshrc_backup
cp $SCRIPTS_DIR/settings/.zshrc ~/.zshrc
cp $SCRIPTS_DIR/settings/.zshenv ~/.zshenv
