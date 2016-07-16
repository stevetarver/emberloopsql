#!/bin/bash

# Pull the Percona 5.7 image, create a container based on it, and initialize
# the database from the contacts export.
#
# Will remove any existing docker container named DOCKER_CONTAINER_NAME
#
# Sources my.cnf additions from
#   $MY_CNF_DIR
# Initializes database from
#   $DUMP_FILE

source ./config.sh

# Create the conf.d directory if it does not already exist
mkdir -p $MY_CNF_DIR

# Delete any existing docker container with the same name
docker stop $DOCKER_CONTAINER_NAME
docker rm -v $DOCKER_CONTAINER_NAME

# Pull the dokcer image and create a container on it
docker run --name $DOCKER_CONTAINER_NAME \
    -p 3306:3306 \
    --restart=always \
    -v $MY_CNF_DIR:/etc/mysql/conf.d \
    -e MYSQL_ROOT_PASSWORD=root \
    -d $DOCKER_IMAGE

# Give the Percona container some time to start and initialize
sleep 10

# Create a new container, link it to datastore:mysql command line client
# and import our dump. A separate container is used to isolate the volume
# shared for import - it is deleted after the import completes.
docker run -it --link $DOCKER_CONTAINER_NAME:mysql \
  -v $DUMPS_DIR:/tmp/import \
  --rm \
  $DOCKER_IMAGE \
  sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" < /tmp/import/'$DUMP_FILE''
