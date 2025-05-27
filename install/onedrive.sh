echo "🚀 Installing dlang"

sudo curl -fsSL https://dlang.org/d-keyring.gpg -o /etc/apt/trusted.gpg.d/dlang.gpg

curl -fsS https://dlang.org/install.sh | bash -s dmd
sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.gold" 20
sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.bfd" 10

echo "✅ dlang installed"

echo "🚀 Installing onedrive"

cd /tmp
git clone https://github.com/abraunegg/onedrive.git
cd onedrive

echo "📥 OneDrive cloned"

folder=$(fdfind "^dmd-[0-9\.]+" ~/dlang)
source $folder/activate

echo "🚀 Building and installing OneDrive"

./configure
make clean
make
sudo make install
deactivate

echo "✅ OneDrive installed"
