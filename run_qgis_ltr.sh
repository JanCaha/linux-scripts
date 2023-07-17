#!/bin/bash
docker pull qgis/qgis:release-3_28

xhost +
docker run --rm -it \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=unix$DISPLAY \
    qgis/qgis:release-3_28 \
    /bin/bash -c qgis
xhost -
