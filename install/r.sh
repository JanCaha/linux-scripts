BASEDIR=$(dirname "$(readlink -f "$0")")

# R
sudo apt-get install -y \
    r-base \
    r-base-dev

# Radian shell for R
pip3 install -U radian --break-system-packages

# R packages
Rscript $BASEDIR/install_packages.R
