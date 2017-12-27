#!/usr/bin/env bash

N=4

YELLOW='\033[1;33m'
RESET='\033[0m'

echo -ne "${YELLOW}Pulling image from local registry ..."
docker pull --insecure-registry localhost:5000/hadoop:latest &> /dev/null
echo -e " DONE${RESET}"

echo -ne "${YELLOW}Starting ${N} slaves (datanode) ..."
docker service rm hadoop-slaves &> /dev/null
docker service create \
       --network=hadoop-swarm \
       --name=hadoop-slaves \
       --replicas=${N} \
       --hostname="" \
       --tty \
       localhost:5000/hadoop:latest
echo -e " DONE${RESET}"
