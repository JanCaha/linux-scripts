#!/bin/bash
set -e

# Variables – change as needed
FTP_USER=""
FTP_PASSWORD=""
FTP_DIR=""

echo "=== Creating FTP directory ==="

if [[ ! -d "$FTP_DIR" ]]; then
    sudo mkdir -p "$FTP_DIR"
    sudo chown nobody:nogroup "$FTP_DIR"
    sudo chmod a-w "$FTP_DIR"
fi

echo "=== Creating FTP user ==="
# Create user without shell access
if id "$FTP_USER" &>/dev/null; then
  echo "User $FTP_USER already exists, skipping creation."
else
  sudo adduser --home "$FTP_DIR" --shell /usr/sbin/nologin --gecos "" "$FTP_USER"
fi
echo "$FTP_USER:$FTP_PASSWORD" | sudo chpasswd

echo "=== Backing up original vsftpd.conf ==="
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak.$(date +%F-%H%M%S)

echo "=== Configuring vsftpd ==="
# Overwrite config with secure basic local FTP config
sudo tee /etc/vsftpd.conf > /dev/null <<'EOF'
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
chroot_local_user=YES
allow_writeable_chroot=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO
EOF

echo "=== Restarting vsftpd ==="
sudo systemctl restart vsftpd
sudo systemctl enable vsftpd

echo "=== FTP server setup complete ==="
echo "Connect with: ftp://$(hostname -I | awk '{print $1}')"
echo "Username: $FTP_USER"
echo "Password: $FTP_PASSWORD"