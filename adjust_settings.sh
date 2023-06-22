ZSHFILE=~/.zshrc

LINE=$(grep "^export PATH" $ZSHFILE)
EXPORT_PATH='export PATH=$HOME/.cargo/bin:$HOME/Scripts/python:$HOME/Scripts:$HOME/bin:/usr/local/bin:$PATH:'

if [ ! -z "$LINE" ];
then
    sd -s $LINE $EXPORT_PATH $ZSHFILE
    echo "PATH variable FOUND and REPLACED"
else
    echo $EXPORT_PATH >> $ZSHFILE
    echo "Added PATH variable"
fi

echo "source /etc/os-release" >> $ZSHFILE
echo 'alias open="nohup nemo . > /dev/null 2>&1 &"' >> $ZSHFILE
