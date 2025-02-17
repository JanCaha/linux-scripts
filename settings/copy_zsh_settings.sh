SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

echo "📂 Copying files .zshenv, .zshrc from $SCRIPT_DIR to $HOME" 

cp $SCRIPT_DIR/.zshrc $HOME/.zshrc
cp $SCRIPT_DIR/.zshenv $HOME/.zshenv
cp $SCRIPT_DIR/.zprofile $HOME/.zprofile

echo "✅ Done copying files .zshenv, .zshrc from $SCRIPT_DIR to $HOME"