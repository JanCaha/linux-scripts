cd ~/Applications
if [ ! -d "OneDriveGUI" ]; then
    git clone https://github.com/bpozdena/OneDriveGUI.git
    cd OneDriveGUI
else
    cd OneDriveGUI
    git pull
fi
python3 -m pip install -r requirements.txt
cd src/
python3 OneDriveGUI.py