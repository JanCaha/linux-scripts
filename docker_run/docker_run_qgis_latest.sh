#!/bin/bash
BASEDIR=$(dirname "$0")

source $BASEDIR/docker_envs.sh

docker build -t qgis-dev -f $DOCKER_IMAGES/QGIS-nightly-unstable.dockerfile $DOCKER_IMAGES

xhost +
docker run --rm -it \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /home/$USER/.local/share/QGIS/QGIS3:/root/.local/share/QGIS/QGIS3 \
    -v /home/$USER:/home/$USER \
    -p 5678:5678 \
    -e DISPLAY=unix$DISPLAY \
    qgis-dev \
    /bin/bash -c qgis
xhost -

sudo chown -R $USER $HOME/.local/share/QGIS