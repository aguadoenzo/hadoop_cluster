#!/usr/bin/env bash

YELLOW='\033[1;33m'
RESET='\033[0m'

# Build image
echo -ne "${YELLOW}Building image ..."
docker build --tag=aguadoe/hadoop . &> /dev/null
echo -e " DONE${RESET}"

# Create network
echo -ne "${YELLOW}Creating network ..."
docker network create --driver=bridge hadoop-network &> /dev/null
echo -e " DONE${RESET}"

# Start master node
docker rm -f hadoop-master &> /dev/null
echo -ne "${YELLOW}Starting namenode (master) ..."
docker run -itd \
       --net=hadoop-network \
       -p 50070:50070 \
       -p 8088:8088 \
       -p 9000:9000 \
       --name hadoop-master \
       --hostname hadoop-master \
       aguadoe/hadoop &> /dev/null
echo -e "DONE${RESET}"


# Start slave nodes
NODES=3 # Number of total nodes (1 master, N - 1 slaves)
i=1
while [ $i -lt $NODES ]
do
    docker rm -f hadoop-slave$i &> /dev/null
    echo -ne "${YELLOW}Starting datanode ${i} (slave) ..." 
    docker run -itd \
	   --net=hadoop-network \
	   --name hadoop-slave$i \
	   --hostname hadoop-slave$i \
	   aguadoe/hadoop &> /dev/null
    echo -e "DONE${RESET}" 
    let "i++"
done 

