#!/bin/bash

containers=$(docker ps -a -f name='cluster' -q)

if [ -n "$containers" ]; then
    echo "removing the containers"
    docker ps -a -f name='cluster'
    docker rm -f $containers
else
    echo "No containers found!"
    docker ps -a -f name='cluster'
fi
