#!/bin/bash

# Restart our properly configured docker machine, and connect to it
# Use to quickly restart the container to pickup config changes
#
# NOTE: this could be improved by just restarting mysqld

./stop.sh
./start.sh