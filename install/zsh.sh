echo "🚀 Installing Zsh and plugins"

# Check if Zsh is installed
if command -v zsh >/dev/null 2>&1; then
    echo "✅ Zsh is already installed"
else
    echo "❌ Zsh is not installed, installing now"
    sudo apt-get install -y zsh
fi

# Check if the current shell is Zsh
if [ "$SHELL" = "$(which zsh)" ]; then
    echo "✅ Current shell is Zsh"
else
    echo "❌ Current shell is not Zsh"
    chsh -s $(which zsh)
fi

echo "✅ Zsh installed and set as default shell"

# Check if ~/.oh-my-zsh exists before removing it
if [ -d "~/.oh-my-zsh" ]; then
    sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
    echo "✅ Oh-my-zsh installed"

    # install additions
    cd ~/.oh-my-zsh/custom/plugins
    git clone https://github.com/zpm-zsh/zshmarks.git bookmarks
    git clone https://github.com/zpm-zsh/zshmarks.git git

    echo "✅ Oh-my-zsh plugins bookmarks and git installed"
else
    echo "❌ Oh-my-zsh exist at: ~/.oh-my-zsh"
fi
