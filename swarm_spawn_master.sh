#!/usr/bin/env bash

N=4

YELLOW='\033[1;33m'
RESET='\033[0m'

echo -ne "${YELLOW}Init swarm mode ..."
docker swarm init &> /dev/null
echo -e " DONE${RESET}"

echo -ne "${YELLOW}Run the following command on slave nodes :${RESET}\n\n	export SWARM_TOKEN="
docker swarm join-token worker --quiet
echo -ne "	export HOST_IP="
hostname -i | awk '{print $1}'
echo -e "\n${RESET}"


# We need to run a private registry because Swarm mode doesn't share local
# images with docker daemon, and always try to pull images from a registry.
echo -ne "${YELLOW}Running local private repository ..."
docker run -d -p 5000:5000 --restart=always --name registry registry:2 &> /dev/null
echo -e " DONE${RESET}"

# Build image
echo -ne "${YELLOW}Building image ..."
docker build --tag=192.168.61.132:5000/hadoop . &> /dev/null
echo -e " DONE${RESET}"

echo -ne "${YELLOW}Pushing image to local registry ..."
docker push 192.168.61.132:5000/hadoop:latest &> /dev/null
echo -e " DONE${RESET}"

# Create network
echo -ne "${YELLOW}Creating network ..."
docker network create --driver=overlay hadoop-swarm &> /dev/null
echo -e " DONE${RESET}"

echo -ne "${YELLOW}Starting master (namenode) ..."
docker service rm hadoop-master &> /dev/null
docker service create \
       --network=hadoop-swarm \
       --name=hadoop-master \
       --hostname=hadoop-master \
       --tty \
       --replicas=1 \
       -p 8088:8088 \
       192.168.61.132:5000/hadoop:latest 
echo -e " DONE${RESET}"

