ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

DISABLE_MAGIC_FUNCTIONS="true"

plugins=(git bookmarks zsh-autosuggestions zsh-syntax-highlighting conda python pip virtualenv)

source $ZSH/oh-my-zsh.sh

source /etc/os-release

if [[ "$TERM_PROGRAM" == "vscode" && -f ".env" ]]; then
  source .env && \
  echo "✅ loaded .env"
fi

git_apply_changes() {
  if [ -z "$1" ]; then
    echo "Path to result file is not set."
    return 1
  fi

  git apply $1
}

git_export_changes() {
  if [ -z "$1" ]; then
    echo "Path to result file is not set."
    exit 1
  fi

  COMMIT_HASH=$(git rev-parse --short HEAD)
  git diff  > $1
}

screenshot(){
  SCREENSHOT_DIR=$HOME/Pictures/Screenshots

  if [ ! -d "$SCREENSHOT_DIR" ]; then
    mkdir -p $SCREENSHOT_DIR
  fi

  if [ -z "$1" ]; then
    echo "Timing not set using default value 5."
    delay=5
  else
    echo "Timing set to $1."
    delay=$1
  fi

  gnome-screenshot -c --delay=$delay -f $SCREENSHOT_DIR/$(date +%Y-%m-%d-%H-%M-%S).png
}

git_commit_exists(){
    if [ -z "$1" ]; then
        return 1
    fi
    git rev-parse --verify "$1" >/dev/null 2>&1
    return $?
}

git_export_commits_since(){
  if [ -z "$1" ]; then
    echo "Starting commit not set file is not set."
    exit 1
  fi

  if ! git_commit_exists "$1"; then
      echo "Invalid commit hash: $1"
      return 1
  fi

  git format-patch $1
}

git_apply_commit_patches() {
    if [ -z "$1" ]; then
        echo "Patches directory not specified"
        return 1
    fi

    if [ ! -d "$1" ]; then
        echo "Directory $1 does not exist"
        return 1
    fi

    # Apply patches in numerical order
    for patch in "$1"/*.patch; do
        if [ -f "$patch" ]; then
            echo "Applying patch: $patch"
            git am "$patch"
            if [ $? -ne 0 ]; then
                echo "Failed to apply patch: $patch"
                git am --abort
                return 1
            fi
        fi
    done
}

alias open="nohup nemo . > /dev/null 2>&1 &"
alias sleep_computer="systemctl suspend"

alias venv_global_activate="source $PYTHON_ENVS_DIR/$MAIN_ENV/bin/activate"

alias gitreset="git reset --hard"
alias git_merge_upstream="git fetch upstream && git merge upstream/master"
alias git_branch_latest="git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)'"

alias find_package="apt search"

alias r="radian"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/cahik/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/cahik/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/cahik/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/cahik/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
