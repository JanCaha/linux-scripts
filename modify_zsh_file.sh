#!/bin/bash
ZSHFILE=~/.zshrc

LINE=$(grep "^export PATH" $ZSHFILE)
EXPORT_PATH='export PATH=$PATH:$HOME/.cargo/bin:$HOME/Scripts/tools:$HOME/Scripts/python:$HOME/Scripts:$HOME/bin:/usr/local/texlive/2024/bin/x86_64-linux'

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
echo 'alias sleep_computer="systemctl suspend"' >> $ZSHFILE

echo 'alias git_merge_upstream="git fetch upstream && git merge upstream/master"' >> $ZSHFILE
echo 'alias gitreset="git reset --hard"' >> $ZSHFILE

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

tee -a $ZSHFILE <<EOF
git_commit_exists(){
    if [ -z "\$1" ]; then
        return 1
    fi
    git rev-parse --verify "\$1" >/dev/null 2>&1
    return \$?
}
EOF

tee -a $ZSHFILE <<EOF
git_export_commits_since(){
  if [ -z "\$1" ]; then
    echo "Starting commit not set file is not set."
    exit 1
  fi

  if ! git_commit_exists "\$1"; then
      echo "Invalid commit hash: \$1"
      return 1
  fi

  git format-patch \$1
}
EOF


tee -a $ZSHFILE <<EOF
git_apply_commit_patches() {
    if [ -z "\$1" ]; then
        echo "Patches directory not specified"
        return 1
    fi

    if [ ! -d "\$1" ]; then
        echo "Directory \$1 does not exist"
        return 1
    fi

    # Apply patches in numerical order
    for patch in "\$1"/*.patch; do
        if [ -f "\$patch" ]; then
            echo "Applying patch: \$patch"
            git am "\$patch"
            if [ \$? -ne 0 ]; then
                echo "Failed to apply patch: \$patch"
                git am --abort
                return 1
            fi
        fi
    done
}
EOF

tee -a $ZSHFILE <<EOF
screenshot(){
  SCREENSHOT_DIR=\$HOME/Pictures/Screenshots

  if [ ! -d "\$SCREENSHOT_DIR" ]; then
    mkdir -p \$SCREENSHOT_DIR
  fi

  if [ -z "\$1" ]; then
    echo "Timing not set using default value 5."
    delay=5
  else
    echo "Timing set to \$1."
    delay=\$1
  fi

  gnome-screenshot -c --delay=\$delay -f \$SCREENSHOT_DIR/$(date +%Y-%m-%d-%H-%M-%S).png
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