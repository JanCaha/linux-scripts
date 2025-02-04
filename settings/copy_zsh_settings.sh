SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

echo "📂 Copying files .zshenv, .zshrc from $SCRIPT_DIR" 

cp $SCRIPTS_DIR/.zshrc $HOME/.zshrc
cp $SCRIPTS_DIR/.zshenv $HOME/.zshenv

echo "✅ Done copying files .zshenv, .zshrc from $SCRIPT_DIR"