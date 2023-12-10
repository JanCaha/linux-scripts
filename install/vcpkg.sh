# VCPKG
cd ~
git clone https://github.com/microsoft/vcpkg.git
echo "VCPKG_ROOT=~/vcpkg" | sudo tee -a /etc/environment
$VCPKG_ROOT/bootstrap-vcpkg.sh
