#!/bin/bash
set -euo pipefail

# Configurable values (override by exporting env vars before running)
SAMBA_USER="${SAMBA_USER:-${USER:-}}"
SAMBA_GROUP="${SAMBA_GROUP:-sambashare}"
SAMBA_SHARE_NAME="${SAMBA_SHARE_NAME:-shared_folder}"
SAMBA_SHARE_PATH="${SAMBA_SHARE_PATH:-/srv/samba/shared}"
SAMBA_SHARE_COMMENT="${SAMBA_SHARE_COMMENT:-Shared Folder}"
SAMBA_ALLOWED_SUBNET="${SAMBA_ALLOWED_SUBNET:-}"
ENABLE_NMBD="${ENABLE_NMBD:-false}"

if [[ -z "${SAMBA_USER}" ]]; then
	echo "Could not determine SAMBA_USER. Set SAMBA_USER and re-run."
	exit 1
fi

if ! id -u "${SAMBA_USER}" >/dev/null 2>&1; then
	echo "Linux user '${SAMBA_USER}' does not exist. Create it or set SAMBA_USER."
	exit 1
fi

sudo apt-get update
sudo apt-get install -y samba

sudo groupadd "${SAMBA_GROUP}" 2>/dev/null || true
sudo usermod -aG "${SAMBA_GROUP}" "${SAMBA_USER}"

sudo install -d -m 2770 -o root -g "${SAMBA_GROUP}" "${SAMBA_SHARE_PATH}"

sudo cp /etc/samba/smb.conf "/etc/samba/smb.conf.bak.$(date +%Y%m%d-%H%M%S)"

# Remove old managed block, then append the current managed block.
sudo sed -i '/# BEGIN MANAGED SAMBA SHARE/,/# END MANAGED SAMBA SHARE/d' /etc/samba/smb.conf

if [[ -n "${SAMBA_ALLOWED_SUBNET}" ]]; then
	HOSTS_ALLOW_LINE="   hosts allow = ${SAMBA_ALLOWED_SUBNET}"
else
	HOSTS_ALLOW_LINE=""
fi

{
	echo
	echo "# BEGIN MANAGED SAMBA SHARE"
	echo "[${SAMBA_SHARE_NAME}]"
	echo "   comment = ${SAMBA_SHARE_COMMENT}"
	echo "   path = ${SAMBA_SHARE_PATH}"
	echo "   browseable = yes"
	echo "   read only = no"
	echo "   valid users = @${SAMBA_GROUP}"
	echo "   force group = ${SAMBA_GROUP}"
	echo "   create mask = 0660"
	echo "   directory mask = 2770"
	if [[ -n "${HOSTS_ALLOW_LINE}" ]]; then
		echo "${HOSTS_ALLOW_LINE}"
	fi
	echo "# END MANAGED SAMBA SHARE"
} | sudo tee -a /etc/samba/smb.conf >/dev/null

sudo testparm -s >/dev/null

echo "Set Samba password for user '${SAMBA_USER}'."
if [[ -n "${SAMBA_PASSWORD:-}" ]]; then
	printf '%s\n%s\n' "${SAMBA_PASSWORD}" "${SAMBA_PASSWORD}" | sudo smbpasswd -s -a "${SAMBA_USER}"
else
	sudo smbpasswd -a "${SAMBA_USER}"
fi
sudo smbpasswd -e "${SAMBA_USER}"

sudo systemctl enable smbd
sudo systemctl restart smbd

if [[ "${ENABLE_NMBD}" == "true" ]]; then
	sudo systemctl enable nmbd
	sudo systemctl restart nmbd
fi

if command -v ufw >/dev/null 2>&1; then
	sudo ufw allow samba
	sudo ufw reload
fi

echo "Samba setup complete."
echo "Share: [${SAMBA_SHARE_NAME}] -> ${SAMBA_SHARE_PATH}"
echo "User: ${SAMBA_USER} (group: ${SAMBA_GROUP})"