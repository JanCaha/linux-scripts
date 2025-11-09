echo "🚀 Installing dlang"

# python3 ~/Scripts/python/download_dlang.py

cd /tmp
sudo curl -LO https://downloads.dlang.org/releases/2.x/2.111.0/dmd_2.111.0-0_amd64.deb
sudo gdebi dmd_2.111.0-0_amd64.deb

echo "✅ dlang installed"

echo "🚀 Installing onedrive"

cd /tmp
git clone https://github.com/abraunegg/onedrive.git
cd onedrive

echo "📥 OneDrive cloned"

sudo apt-get install -y \
    libdbus-1-dev

# folder=$(fdfind "^dmd-[0-9\.]+" ~/dlang)
# source $folder/activate

echo "🚀 Building and installing OneDrive"

./configure
make clean
make
sudo make install
# deactivate

echo "✅ OneDrive installed"
