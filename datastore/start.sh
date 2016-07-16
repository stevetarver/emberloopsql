#!/bin/bash

# Start our properly configured docker machine, and connect to it

source ./config.sh

docker start $DOCKER_CONTAINER_NAME