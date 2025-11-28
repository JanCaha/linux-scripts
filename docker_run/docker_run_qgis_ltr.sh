#!/bin/bash
BASEDIR=$(dirname "$0")

source $BASEDIR/docker_envs.sh

docker build \
    -t qgis-ltr \
    -f $DOCKER_IMAGES/QGIS-ltr.dockerfile $DOCKER_IMAGES

xhost +
docker run --rm -it \
    --user $(id -u):$(id -g) \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $DIR_WORK \
    -v $DIR_CODES \
    -v $DIR_QGIS_PROFILES \
    -p 127.0.0.1:5678:5678 \
    -e DISPLAY=unix$DISPLAY \
    qgis-ltr \
    /bin/bash -c qgis
xhost -

sudo chown -R $USER $HOME/.local/share/QGIS
