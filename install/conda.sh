echo "🚀 Installing MicroMamba"

# MicroMamba
cd /tmp
curl -L micro.mamba.pm/install.sh | bash -s

echo "✅ MicroMamba installed"

echo "🚀 Installing packages to base environment"

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