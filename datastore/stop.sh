#!/bin/bash

# Stop our properly configured docker machine

source ./config.sh

docker stop $DOCKER_CONTAINER_NAME
