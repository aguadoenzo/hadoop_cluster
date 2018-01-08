# Hadoop cluster

Made for an assignement, not fit for anyting remotely serious.

## Getting started

You need at least one Docker Swarm manager
```sh
# On manager
docker swarm init
```
This will print a command that you'll need to run on all other nodes.


## Starting the cluster

We use Docker Deploy to start and manage the services.
```sh
docker stack deploy --compose-file=docker-compose.yml [name of the cluster]
```

## Useful stuff

#### Visualize cluster health
You can access a visualizer by using a brower to go to `[IP]:8080` where `IP` is a node in the cluster (any node should work).

#### Query logs of a service (all container of one kind)
To get an aggregated log of all the containers of a specific service, run
```sh
docker service logs [service name]
```
Docker service names can be found with
```sh
docker service ls
```

#### Enter in a node to issue commands
Executing `docker ps` will list all containers running on one node.

```sh
docker exec -it [container name] bash
```

### Known issues
 - Running the cluster on non linux hosts may cause issues with docker DNS (VIP)
 - Restarting the master causes all the nodes to fail.
