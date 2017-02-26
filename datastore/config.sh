#!/bin/bash

# A place for common name definition
# Each script should: source ./config.sh

DOCKER_IMAGE=percona:5.7
DOCKER_CONTAINER_NAME=datastore
MY_CNF_DIR=`pwd`/conf.d
DUMPS_DIR=`pwd`/dumps
DUMP_FILE=us-contacts-500.sql
DUMP_PATH=$DUMPS_DIR/$DUMP_FILE
