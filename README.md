# Hadoop cluster

## Running in distributed
```sh
# On master machine
./swarm_spawn_master.sh
```

```sh
# On slave machine
# You need to execute the commands output by master first
./swarm_spawn_slaves.sh
```


## Running in local (pseudo distributed)
### Getting started
```sh
git clone git@github.com:aguadoenzo/hadoop_cluster.git
cd hadoop_cluster
./local_build_containers.sh
./local_login_master.sh
```

### Useful commands
```sh
hdfs dfsadmin -report # List live nodes and their health

hdfs dfs -ls  # List files in the HDFS
hdfs dfs -cat path/to/file # Cat a file
```

## MapReduce example - word count

Find a lot of text to begin with. Hadoop is slow to wake up, so small datasets will not show good performances.

```
mkdir input/
# Add lots of files to input/
hdfs dfs -mkdir -p input	# Create input directory on HDFS
hdfs dfs -put input/* input	# Copy files in it
hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.0.jar wordcount input output
hdfs dfs -cat output/part-r-00000

```