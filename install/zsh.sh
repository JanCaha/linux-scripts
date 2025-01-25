sudo apt-get install -y zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
chsh -s $(which zsh)

# install additons
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zpm-zsh/zshmarks.git bookmarks