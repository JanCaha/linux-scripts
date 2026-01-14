mkdir -p ~/.config/systemd/user/

touch ~/.config/systemd/user/ssh-agent.service

cat << 'EOF' | tee ~/.config/systemd/user/ssh-agent.service
[Unit]
Description=User SSH Agent

[Service]
Type=simple
Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket
ExecStart=/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK

[Install]
WantedBy=default.target
EOF

systemctl --user enable ssh-agent
systemctl --user start ssh-agent

echo export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket" >> ~/.profile