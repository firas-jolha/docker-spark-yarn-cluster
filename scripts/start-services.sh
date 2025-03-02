#!/bin/bash

# starting HDFS daemons
$HADOOP_HOME/sbin/start-dfs.sh

# starting Yarn daemons
$HADOOP_HOME/sbin/start-yarn.sh

# track process IDs of services
jps -lm

# subtool to perform administrator functions on HDFS
# outputs a brief report on the overall HDFS filesystem
hdfs dfsadmin -report

# create a directory for spark apps in HDFS
hdfs dfs -mkdir -p /apps/spark

# Copy all jars to HDFS
zip /usr/local/spark/jars/spark-jars.zip /usr/local/spark/jars/*
hdfs dfs -put /usr/local/spark/jars/spark-jars.zip  /apps/spark

# Starts both a master and a number of workers
$SPARK_HOME/sbin/start-all.sh

# Stops both the master and the workers
# $SPARK_HOME/sbin/stop-all.sh

# print version of Scala of Spark
scala -version

# track process IDs of services
jps -lm



