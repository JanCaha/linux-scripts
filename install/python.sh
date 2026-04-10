echo "🚀 Creating base VENV"

if [ ! -d "$PYTHON_ENVS_DIR" ]; then
    echo "📂 Creating directory $PYTHON_ENVS_DIR"
    sudo mkdir $PYTHON_ENVS_DIR
fi

cd $PYTHON_ENVS_DIR

if [ ! -d "$PYTHON_ENVS_DIR/$MAIN_ENV" ]; then
    echo "🔄 Creating virtual environment $MAIN_ENV"
    sudo python3 -m venv $MAIN_ENV --system-site-packages --symlinks
fi

source $PYTHON_ENVS_DIR/$MAIN_ENV/bin/activate

echo "📦 Installing packages to base VENV"

pip3 install \
    beautifulsoup4 \
    pb_tool \
	mkdocs-bootswatch \
    ocrmypdf \
    pytest-qgis \
    selenium \
    pypdfium2 \
	https://codeload.github.com/mkdocs/mkdocs-bootstrap/zip/master \
	git+https://github.com/it-novum/mkdocs-featherlight.git

echo "✅ Packages installed to base VENV"