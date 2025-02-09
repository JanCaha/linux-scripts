cd ~/Applications
if [ ! -d "OneDriveGUI" ]; then
    git clone https://github.com/bpozdena/OneDriveGUI.git
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

. ~/Applications/OneDriveGUI/.venv/bin/activate
echo "✅ Python VENV activated."

python -m pip install PySide6_Essentials requests

cd src/
python OneDriveGUI.py
