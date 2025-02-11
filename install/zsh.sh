echo "🚀 Installing Zsh and plugins"

sudo apt-get install -y zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
chsh -s $(which zsh)

echo "✅ Zsh installed and set as default shell"

# Check if ~/.oh-my-zsh exists before removing it
if [ -d "~/.oh-my-zsh" ]; then
    rm -rf ~/.oh-my-zsh
fi

# install additions
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zpm-zsh/zshmarks.git bookmarks

echo "✅ Zsh plugins installed"