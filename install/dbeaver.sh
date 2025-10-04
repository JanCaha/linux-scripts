cd /tmp
gh release download --repo dbeaver/dbeaver --pattern "*.deb" --clobber
sudo dpkg -i dbeaver-ce_*.deb
sudo apt-get install -f -y
rm dbeaver-ce_*.deb