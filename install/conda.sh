echo "🚀 Installing MiniConda"

mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh

echo "✅ MiniConda installed"

echo "🚀 Installing packages to base environment"

~/miniconda3/bin/conda init zsh
source ~/.zshrc

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

echo "✅ Packages installed to base environment"


