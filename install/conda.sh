# MicroMamba
cd /tmp
curl -L micro.mamba.pm/install.sh | bash -s

conda activate base

conda install -y \
    beautifulsoup4 \
    nbclient \
    ipykernel \
    pylint \
    pycodestyle \
    flake8 \
    mypy \
    black \
    isort
