#!/bin/bash

docker run \
  --name tooljet \
  --restart unless-stopped \
  -p 81:80 \
  --platform linux/amd64 \
  -v tooljet_data:/home/cahik/_temp/tooljet \
  tooljet/try:ee-lts-latest  