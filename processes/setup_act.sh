#!/bin/bash
BASEDIR=$(dirname "$0")

# build custom runner image with debian trixie
docker build -t gitea-debian-trixie-act:latest -f "$BASEDIR/../docker_images/debian-act-runner.dockerfile" .

mkdir -p ~/act_runner/{config,data}

touch ~/act_runner/config/config.yaml

sudo tee ~/act_runner/config/config.yaml > /dev/null <<'EOF'
log:
  level: info

runner:
  labels:
    - "gitea-debian-trixie-act:latest"

container:
  network: host
  privileged: true
EOF

