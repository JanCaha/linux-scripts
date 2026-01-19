#!/bin/bash
BASEDIR=$(dirname "$0")

# build custom runner image with debian trixie
docker build -t gitea-debian-trixie-act:latest -f "$BASEDIR/../docker_images/debian-act-runner.dockerfile" .

docker build -t gitea-ubuntu-quokka-act:latest -f "$BASEDIR/../docker_images/ubuntu-act-runner.dockerfile" .

mkdir -p ~/act_runner/{config,data,artifacts}

sudo chmod 777 ~/act_runner/artifacts

touch ~/act_runner/config/config.yaml

sudo tee ~/act_runner/config/config.yaml > /dev/null <<EOF
log:
  level: info

runner:
  labels:
    - "ubuntu-latest:docker://gitea-ubuntu-quokka-act:latest"
    - "debian-latest:docker://gitea-debian-trixie-act:latest"

container:
  network: gitea
  privileged: false
  options: "-v $HOME/act_runner/artifacts:/artifacts"
  valid_volumes:
    - "$HOME/act_runner/artifacts"
EOF

