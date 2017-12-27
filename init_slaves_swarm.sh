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
echo -ne "${YELLOW}Manager token is :${RESET}"
docker swarm join --token $SWARM_TOKEN $HOST_IP:2377
echo -n "${YELLOW}. Write it somewhere, you'll need it to add slaves to the cluster${RESET}"

# Build image
echo -ne "${YELLOW}Building image ..."
docker build --tag=$HOST_IP:5000/hadoop . &> /dev/null
echo -e " DONE${RESET}"

echo -ne "${YELLOW}Pushing image to local registry ..."
docker pull --insecure-registry 192.168.61.132:5000/hadoop:latest &> /dev/null
echo -e " DONE${RESET}"


echo -ne "${YELLOW}Starting ${N} slaves (datanode) ..."
docker service rm hadoop-slaves &> /dev/null
docker service create \
       --network=hadoop-swarm \
       --name=hadoop-slaves \
       --replicas=${N} \
       --hostname="" \
       --tty \
       $HOST_IP:5000/hadoop:latest
echo -e " DONE${RESET}"
