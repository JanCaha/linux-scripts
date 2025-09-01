#!/bin/zsh

# COLORS
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PINK="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
NORMAL="\033[0;39m"

cd "$(dirname "$0")"

# check for locks
echo -e "$YELLOW---check apt locks---$NORMAL"

sudo apt-get check >/dev/null 2>&1
if [ "$?" -ne 0 ]; then

    echo 'APT Lock exist!'
    echo 'Delete lock?'

    select yn in "Yes" "No"; do
        case $yn in
        Yes)
            DELETELOCK=true
            break
            ;;
        No)
            DELETELOCK=false
            break
            ;;
        esac
    done

    echo -e "$BLUE Deleting lock. $NORMAL"

    if [ "$DELETELOCK" = true ]; then
        echo 'Deleting locks!'

        sudo killall apt apt-get

        sudo rm /var/lib/apt/lists/lock
        sudo rm /var/cache/apt/archives/lock
        sudo rm /var/lib/dpkg/lock*

        sudo dpkg --configure -a
    fi
fi
echo ""

# apt update
echo -e "$YELLOW---apt update---$NORMAL"
sudo apt update
echo -e "$GREEN---Upgradable packages---"
apt list --upgradable
echo -e "$GREEN---------$NORMAL"
echo -e "\n\n\n"
sudo apt upgrade -y --fix-missing
sudo apt autoremove -y
echo -e "$GREEN---kept back packages---$NORMAL"
apt-get upgrade --dry-run | grep -i "kept back" -A 1000
echo -e "$YELLOW---end apt update---$NORMAL"
echo ""
