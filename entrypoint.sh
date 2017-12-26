#!/bin/bash

echo "Starting HDFS"
$HADOOP_HOME/sbin/start-dfs.sh

echo "Starting YARN"
$HADOOP_HOME/sbin/start-yarn.sh
