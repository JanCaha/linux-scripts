# streaming package
sudo apt-get install -y \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-good1.0-dev \
    gstreamer1.0-plugins-bad

cd /tmp
git clone https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git
cd gst-plugins-rs

meson setup --buildtype=release --default-library=shared --wrap-mode=nodownload --auto-features=disabled -Dspotify=enabled build

cd build
ninja

sudo mkdir /usr/lib64/gstreamer-1.0
sudo cp libgstspotify.so /usr/lib64/gstreamer-1.0/libgstspotify.so
