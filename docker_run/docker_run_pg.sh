#!/bin/bash
BASEDIR=$(dirname "$0")

source $BASEDIR/docker_envs.sh

export CONTAINER_NAME=postgis-machine

RUNS="$( docker container inspect -f '{{.State.Running}}' $CONTAINER_NAME )"

if [ $RUNS = "true" ]; then
    while true; do
        read -p "Close the docker machine? (y/n)" yn
        case $yn in
            [Yy]* ) docker compose -f $DOCKER_COMPOSE/postgresql-postgis-compose.yaml stop; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
else
    docker compose -f $DOCKER_COMPOSE/postgresql-postgis-compose.yaml up -d
fi

sleep 2
