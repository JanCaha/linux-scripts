#!/bin/bash
BASEDIR=$(dirname "$0")

# Load user shell environment variables before using any shell-dependent paths.
if [ -f "$HOME/.zshenv" ]; then
    set -a
    source "$HOME/.zshenv"
    set +a
fi

source "$BASEDIR/docker_envs.sh"

export CONTAINER_NAME="postgis-machine"

if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
    RUNS="$(docker container inspect -f '{{.State.Running}}' "$CONTAINER_NAME")"

    if [ "$RUNS" = "true" ]; then
        while true; do
            read -p "Close the docker machine? (y/n) " yn
            case "$yn" in
                [Yy]*)
                    docker compose -f "$DOCKER_COMPOSE/postgresql-postgis.yaml" stop
                    break
                    ;;
                [Nn]*)
                    exit 0
                    ;;
                *)
                    echo "Please answer yes or no."
                    ;;
            esac
        done
    else
        docker compose -f "$DOCKER_COMPOSE/postgresql-postgis.yaml" up -d
    fi
else
    docker compose -f "$DOCKER_COMPOSE/postgresql-postgis.yaml" up -d
fi

sleep 2
