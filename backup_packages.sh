dpkg --get-selections > data/installed_packages.txt

dpkg --clear-selections
sudo dpkg --set-selections < data/installed_packages.txt