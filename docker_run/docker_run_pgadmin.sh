#!/bin/bash

docker run -it \
    -p 5050:80 \
    -e PGADMIN_DEFAULT_EMAIL=admin@example.com \
    -e PGADMIN_DEFAULT_PASSWORD=secret \
    --name pgdadmin4 \
    dpage/pgadmin4:latest
