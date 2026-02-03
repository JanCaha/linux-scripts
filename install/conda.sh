#!/bin/bash
set -euo pipefail

echo "🚀 Installing MiniConda"

CONDA_DIR=~/miniconda3

mkdir -p "$CONDA_DIR"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O "/tmp/miniconda.sh"
bash "/tmp/miniconda.sh" -b -u -p "$CONDA_DIR"
rm "/tmp/miniconda.sh"

echo "✅ MiniConda installed"

echo "🚀 Installing packages to base environment"

$CONDA_DIR/bin/conda init zsh

$CONDA_DIR/bin/conda config --set solver libmamba

$CONDA_DIR/bin/conda activate base

$CONDA_DIR/bin/conda install -y \
    beautifulsoup4 \
    nbclient \
    ipykernel \
    pylint \
    pycodestyle \
    flake8 \
    mypy \
    black \
    isort

echo "✅ Packages installed to base environment"

# echo "🚀 Installing MicroMamba"

# "${SHELL}" <(curl -L micro.mamba.pm/install.sh)

# echo "✅ MicroMamba installed"
