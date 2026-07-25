#!/bin/bash

containers=$(docker container ls -q)
if [ -n "$containers" ]; then
	docker container kill $containers
else
	echo "No running containers found."
fi