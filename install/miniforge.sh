# MiniForge
cd /tmp
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
# conda init --reverse --dry-run
# conda init --reverse

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

pip3 install \
    ocrmypdf \
    pytest-qgis \
    mkdocs-bootswatch 
    pb_tool \
	https://codeload.github.com/mkdocs/mkdocs-bootstrap/zip/master \
	git+https://github.com/it-novum/mkdocs-featherlight.git
