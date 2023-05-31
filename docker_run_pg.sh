export HOME_DIR=~

DOCKER_CONTAINER=$(docker ps -q -f name="postgis-machine")
docker compose -f $HOME_DIR/Scripts/docker_compose/postgresql-postgis-compose.yaml up -d
# docker compose -f docker_compose/postgresql-postgis-compose.yaml stop

sleep 5