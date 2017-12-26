# Hadoop cluster

### Getting started
```sh
git clone git@github.com:aguadoenzo/hadoop_cluster.git
cd hadoop_cluster
./build_containers.sh
./go_master.sh
```

### Useful commands
```sh
hdfs dfsadmin -report # List live nodes and their health

hdfs dfs -ls  # List files in the HDFS
hdfs dfs -cat path/to/file # Cat a file
```