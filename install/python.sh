if [ ! -d "$PYTHON_ENVS_DIR" ]; then
    echo "Creating directory $PYTHON_ENVS_DIR"
    sudo mkdir $PYTHON_ENVS_DIR
fi

cd $PYTHON_ENVS_DIR

if [ ! -d "$PYTHON_ENVS_DIR/$MAIN_ENV" ]; then
    sudo python3 -m venv $MAIN_ENV --system-site-packages --symlinks
fi

source /.$MAIN_ENV_ACTIVATE

pip3 install \
    beautifulsoup4 \
    pb_tool \
	mkdocs-bootswatch \
    ocrmypdf \
    pytest-qgis \
    selenium \
	https://codeload.github.com/mkdocs/mkdocs-bootstrap/zip/master \
	git+https://github.com/it-novum/mkdocs-featherlight.git