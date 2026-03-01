#!/bin/bash
set -euo pipefail

START_DIR="$(pwd)"

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
    chsh -s "$(which zsh)"
fi

echo "✅ Zsh installed and set as default shell"

# Check if ~/.oh-my-zsh does NOT exist before installing
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
    echo "✅ Oh-my-zsh installed"

    # install additions
    mkdir -p "$HOME/.oh-my-zsh/custom/plugins"
    cd "$HOME/.oh-my-zsh/custom/plugins"
    git clone https://github.com/zpm-zsh/zshmarks.git bookmarks || true
    git clone https://github.com/zpm-zsh/zshmarks.git git || true
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git || true
    git clone https://github.com/zsh-users/zsh-autosuggestions.git || true

    echo "✅ Oh-my-zsh plugins installed"
else
    echo "✅ Oh-my-zsh already exists at: $HOME/.oh-my-zsh"
fi

cd "$START_DIR"
