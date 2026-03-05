#!/bin/bash

HOST_PREFIX="cluster"
NETWORK_NAME=$HOST_PREFIX

# Stop and remove only the cluster containers (cluster-master, cluster-slave-*)
CONTAINERS=$(docker ps -a --filter "name=^/${HOST_PREFIX}-" --format "{{.Names}}")

if [ -z "$CONTAINERS" ]; then
    echo "No cluster containers found."
else
    echo "Stopping containers: $CONTAINERS"
    docker stop $CONTAINERS
    docker rm $CONTAINERS
fi

# Remove the cluster network if it exists
if docker network ls | grep -q "^.*\s${NETWORK_NAME}\s"; then
    echo "Removing network: $NETWORK_NAME"
    docker network rm $NETWORK_NAME
fi



