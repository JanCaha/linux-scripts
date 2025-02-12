BASEDIR=$(dirname "$(readlink -f "$0")")

# R
sudo apt-get install -y \
    r-base \
    r-base-dev

# R packages
Rscript $BASEDIR/install_packages.R
