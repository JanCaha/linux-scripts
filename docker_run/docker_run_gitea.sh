#!/bin/bash
BASEDIR=$(dirname "$0")

source $BASEDIR/docker_envs.sh

## create requierd gitea network
docker network inspect gitea >/dev/null 2>&1 || docker network create gitea

export CONTAINER_NAME=gitea-machine

RUNS="$( docker container inspect -f '{{.State.Running}}' $CONTAINER_NAME )"

if [[ $RUNS == "true" ]]; then
    while true; do
        read -p "Close the docker machine? (y/n)" yn
        case $yn in
            [Yy]* ) docker compose -f $DOCKER_COMPOSE/gitea.yaml stop; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
else
    docker compose -f $DOCKER_COMPOSE/gitea.yaml up -d
fi

sleep 2
