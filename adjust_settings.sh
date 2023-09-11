ZSHFILE=~/.zshrc

LINE=$(grep "^export PATH" $ZSHFILE)
EXPORT_PATH='export PATH=$HOME/.cargo/bin:$HOME/Scripts/python:$HOME/Scripts:$HOME/bin:/usr/local/bin:/usr/local/texlive/2023/bin/x86_64-linux:$PATH:'

if [ ! -z "$LINE" ];
then
    sd -s $LINE $EXPORT_PATH $ZSHFILE
    echo "PATH variable FOUND and REPLACED"
else
    echo $EXPORT_PATH >> $ZSHFILE
    echo "Added PATH variable"
fi

echo "source /etc/os-release" >> $ZSHFILE
echo "source ~/Scripts/variables.sh" >> $ZSHFILE
echo 'alias open="nohup nemo . > /dev/null 2>&1 &"' >> $ZSHFILE
echo 'alias gitreset="git reset --hard"' >> $ZSHFILE
echo 'alias sleep_computer="systemctl suspend"' >> $ZSHFILE
echo 'alias conda_activate="source ~/miniconda3/etc/profile.d/conda.sh"' >> $ZSHFILE

# install additons
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zpm-zsh/zshmarks.git bookmarks # activate by adding bookmarks to ~/.zshrc plugins=(plugins)
