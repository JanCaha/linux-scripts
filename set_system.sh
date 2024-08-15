# fonts folder from OneDrive
rm -rf ~/.local/share/fonts/
ln -sd ~/OneDrive/Fonts/fonts_folder/ ~/.local/share/fonts/
sudo fc-cache -v

# Scripts 
mkdir -p ~/Codes
cd ~/Codes
git clone https://github.com/JanCaha/linux-scripts.git
ln -sd ~/Codes/linux-scripts ~/Scripts
cd ~