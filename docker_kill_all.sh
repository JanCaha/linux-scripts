#!/bin/zsh
docker container kill $(docker container ls -q)