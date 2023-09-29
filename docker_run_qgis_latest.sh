#!/bin/zsh
BASEDIR=$(dirname "$0")

docker build -t qgis-dev -f $BASEDIR/docker/QGIS-nigthly-unstable.dockerfile .

xhost +
docker run --rm -it \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /home/$USER:/home/$USER \
    -p 127.0.0.1:5678:5678 \
    -e DISPLAY=unix$DISPLAY \
    qgis-dev \
    /bin/bash -c qgis
xhost -