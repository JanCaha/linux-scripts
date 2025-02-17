#!/bin/zsh
BASEDIR=$(dirname "$0")

docker build -t qgis-ltr -f $BASEDIR/docker/QGIS-328.dockerfile .

xhost +
docker run --rm -it \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $DIR_WORK \
    -v $DIR_CODES \
    -v $DIR_QGIS_PROFILES \
    -p 127.0.0.1:5678:5678 \
    -e DISPLAY=unix$DISPLAY \
    qgis-ltr \
    /bin/bash -c qgis
xhost -

sudo chown -R $USER /home/$USER/.local/share/QGIS