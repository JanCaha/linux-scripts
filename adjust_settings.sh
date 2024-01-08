ZSHFILE=~/.zshrc

LINE=$(grep "^export PATH" $ZSHFILE)
EXPORT_PATH='export PATH=$PATH:$HOME/.cargo/bin:$HOME/Scripts/tools:$HOME/Scripts/python:$HOME/Scripts:$HOME/bin:/usr/local/texlive/2023/bin/x86_64-linux'

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

GREETER_FILE=/etc/lightdm/slick-greeter.conf
LINE=$(grep "^activate-numlock=" $GREETER_FILE)
LINE_NUMLOCK_ON="activate-numlock=true"

echo "greeter-setup-script=/usr/bin/numlockx on" | sudo tee /etc/lightdm/lightdm.conf

if [ ! -z "$LINE" ];
then
    sd -s $LINE $LINE_NUMLOCK_ON $GREETER_FILE
else
    echo $LINE_NUMLOCK_ON >> $GREETER_FILE
fi