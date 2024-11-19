#!/bin/bash
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
source ~/Scripts/variables.sh
echo 'alias open="nohup nemo . > /dev/null 2>&1 &"' >> $ZSHFILE
echo 'alias gitreset="git reset --hard"' >> $ZSHFILE
echo 'alias sleep_computer="systemctl suspend"' >> $ZSHFILE
echo 'alias conda_activate="source ~/miniconda3/etc/profile.d/conda.sh"' >> $ZSHFILE
echo 'alias git_merge_upstream="git fetch upstream && git merge upstream/master"' >> $ZSHFILE

tee -a $ZSHFILE <<EOF
git_export_changes() {
  if [ -z "\$1" ]; then
    echo "Path to result file is not set."
    exit 1
  fi

  COMMIT_HASH=\$(git rev-parse --short HEAD)
  git diff $COMMIT_HASH > \$1
}
EOF

tee -a $ZSHFILE <<EOF
git_apply_changes() {
  if [ -z "\$1" ]; then
    echo "Path to result file is not set."
    exit 1
  fi

  git apply \$1
}
EOF

# install additons
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zpm-zsh/zshmarks.git bookmarks # activate by adding bookmarks to ~/.zshrc plugins=(plugins)

#GREETER_FILE=/etc/lightdm/slick-greeter.conf
#LINE=$(grep "^activate-numlock=" $GREETER_FILE)
#LINE_NUMLOCK_ON="activate-numlock=true"

#echo "greeter-setup-script=/usr/bin/numlockx on" | sudo tee /etc/lightdm/lightdm.conf

#if [ ! -z "$LINE" ];
#then
#    sd -s $LINE $LINE_NUMLOCK_ON $GREETER_FILE
#else
#    echo $LINE_NUMLOCK_ON >> $GREETER_FILE
#fi

echo 'if [[ "$TERM_PROGRAM" == "vscode" && -f ".env" ]]; then
  source .env && \
  echo "✅ loaded .env"
fi' >> $ZSHFILE