#!/usr/bin/env bash

N=4

YELLOW='\033[1;33m'
RESET='\033[0m'


if [ -z "$SWARM_TOKEN" ]; then
    echo "Please export SWARM_TOKEN=..."; exit 1
fi

if [ -z "$HOST_IP" ]; then
    echo "Please export HOST_IP=..."; exit 1
fi
echo -ne "${YELLOW}Joining swarm ..."
docker swarm join --token $SWARM_TOKEN $HOST_IP:2377
echo -e " DONE${RESET}"
