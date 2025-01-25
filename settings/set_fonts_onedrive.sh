# fonts folder from OneDrive
rm -rf ~/.local/share/fonts/
ln -sd ~/OneDrive/Fonts/fonts_folder/ ~/.local/share/fonts
sudo fc-cache -v