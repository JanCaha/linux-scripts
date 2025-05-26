cd ~/Applications
if [ ! -d "OneDriveGUI" ]; then
    git clone -b main https://github.com/bpozdena/OneDriveGUI.git
    cd OneDriveGUI
    echo "✅ OneDriveGUI cloned."
else
    cd OneDriveGUI
    git pull
    echo "✅ OneDriveGUI updated."
fi

VENV_FOLDER=.venv
if [ -d "$VENV_FOLDER" ];then
    echo "VENV $VENV_FOLDER exists."
else
    echo "Creating the VENV $VENV_FOLDER."
    python3 -m venv $VENV_FOLDER --symlinks --system-site-packages 
    echo "✅ VENV created."
fi

. "$(pwd)/$VENV_FOLDER/bin/activate"
echo "✅ Python VENV activated."

python -m pip install -r ~/Applications/OneDriveGUI/requirements.txt

if [ -d "src" ] && [ -f "src/OneDriveGUI.py" ]; then
    cd src/
    python OneDriveGUI.py
else
    echo "❌ Error: 'src/' directory or 'OneDriveGUI.py' file is missing."
    exit 1
fi
