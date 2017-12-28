#!/usr/bin/env bash

YELLOW='\033[1;33m'
RESET='\033[0m'


## TODO: try to find a way to automate manager IP discovery
if [ -z "$1" ]; then
    echo "Please specify master node IP address"; exit 1
fi


echo -ne "${YELLOW}Init swarm mode ..."
docker swarm init &> /dev/null
echo -e " DONE${RESET}"

export SWARM_TOKEN=$(docker swarm join-token worker --quiet)
export HOST_IP=$1

echo -e "${YELLOW}Run the following command on slave nodes :${RESET}\n"
echo -e "	export SWARM_TOKEN=${SWARM_TOKEN}"
echo -e "	export HOST_IP=${HOST_IP}"
echo -e "	./swarm_join.sh\n"


# We need to run a private registry because Swarm mode doesn't share local
# images with docker daemon, and always try to pull images from a registry.
echo -ne "${YELLOW}Running local private repository ..."
docker run -d -p 5000:5000 --restart=always --name registry registry:2 &> /dev/null
echo -e " DONE${RESET}"

# Build image
echo -ne "${YELLOW}Building image ..."
docker build --tag=$HOST_IP:5000/hadoop . &> /dev/null
echo -e " DONE${RESET}"

echo -ne "${YELLOW}Pushing image to local registry ..."
docker push $HOST_IP:5000/hadoop:latest &> /dev/null
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
       -p 9000:9000 \
       -p 50070:50070 \
       $HOST_IP:5000/hadoop:latest 
echo -e " DONE${RESET}"

