ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

DISABLE_MAGIC_FUNCTIONS="true"

plugins=(git bookmarks)

source $ZSH/oh-my-zsh.sh

PATH=$PATH:$HOME/.cargo/bin:$HOME/Scripts/tools:$HOME/Scripts/python:$HOME/Scripts:$HOME/bin:/usr/local/texlive/2024/bin/x86_64-linux:$HOME/.local/bin

source /etc/os-release
source ~/Scripts/variables.sh

alias open="nohup nemo . > /dev/null 2>&1 &"
alias gitreset="git reset --hard"
alias sleep_computer="systemctl suspend"

alias gitreset="git reset --hard"
alias sleep_computer="systemctl suspend"
alias conda_activate="source ~/miniconda3/etc/profile.d/conda.sh"
alias git_merge_upstream="git fetch upstream && git merge upstream/master"

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

alias conda="micromamba"

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/home/cahik/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/cahik/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

alias venv_global_activate_="source $PYTHON_ENVS_DIR/$MAIN_ENV/bin/activate"