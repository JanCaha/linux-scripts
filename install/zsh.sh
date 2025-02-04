echo "🚀 Installing Zsh and plugins"

sudo apt-get install -y zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
chsh -s $(which zsh)

echo "✅ Zsh installed and set as default shell"

# install additons
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zpm-zsh/zshmarks.git bookmarks

echo "✅ Zsh plugins installed"