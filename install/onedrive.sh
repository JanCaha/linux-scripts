echo "🚀 Installing dlang"

# sudo curl -fsSL https://dlang.org/d-keyring.gpg -o /etc/apt/trusted.gpg.d/dlang.gpg
# sudo curl -fsSL https://downloads.dlang.org/other/d-keyring.gpg -o /etc/apt/trusted.gpg.d/dlang-other.gpg

# curl -fsS https://dlang.org/install.sh | bash -s dmd
# sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.gold" 20
# sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.bfd" 10

python3 ~/Scripts/python/download_dlang.py

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
