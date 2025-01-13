curl -fsS https://dlang.org/install.sh | bash -s dmd
sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.gold" 20
sudo update-alternatives --install "/usr/bin/ld" "ld" "/usr/bin/ld.bfd" 10

cd /tmp
git clone https://github.com/abraunegg/onedrive.git
cd onedrive
folder=$(fdfind "^dmd-[0-9\.]+" ~/dlang)
source $folder/activate
./configure
make clean; make;
sudo make install
deactivate