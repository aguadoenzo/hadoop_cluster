#!/usr/bin/env bash

# Build image
docker build --tag=aguadoe/hadoop .

# Create network
docker network create --driver=bridge hadoop-network &> /dev/null

# Start master node
docker rm -f hadoop-master
docker run -itd \
                --net=hadoop-network \
                -p 50070:50070 \
                -p 8088:8088 \
                --name hadoop-master \
                --hostname hadoop-master \
                aguadoe/hadoop


# Start slave nodes
NODES=6 # Number of total nodes (1 master, N - 1 slaves)
i=1
while [ $i -lt $NODES ]
do
	docker rm -f hadoop-slave$i
	echo "start hadoop-slave$i container..."
	docker run -itd \
	                --net=hadoop-network \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                aguadoe/hadoop
	i=$(( $i + 1 ))
done 

