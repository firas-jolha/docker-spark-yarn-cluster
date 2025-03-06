#!/bin/bash
# This will run only by the master node

# starting HDFS daemons
$HADOOP_HOME/sbin/start-dfs.sh

# starting Yarn daemons
$HADOOP_HOME/sbin/start-yarn.sh
# yarn --daemon start resourcemanager

# Start mapreduce history server
mapred --daemon start historyserver


# track process IDs of services
jps -lm

# subtool to perform administrator functions on HDFS
# outputs a brief report on the overall HDFS filesystem
hdfs dfsadmin -report

# create a directory for spark apps in HDFS
hdfs dfs -mkdir -p /apps/spark/jars
hdfs dfs -chmod 744 /apps/spark/jars


# Copy all jars to HDFS
# zip /usr/local/spark/jars/spark-jars.zip /usr/local/spark/jars/*
hdfs dfs -put /usr/local/spark/jars/* /apps/spark/jars/
hdfs dfs -chmod +rx /apps/spark/jars/
# spark-jars.zip  /apps/spark

# Starts both a master and a number of workers
# $SPARK_HOME/sbin/start-all.sh

# Stops both the master and the workers
# $SPARK_HOME/sbin/stop-all.sh

# print version of Scala of Spark
scala -version

# track process IDs of services
jps -lm

# Create a directory for root user on HDFS
hdfs dfs -mkdir -p /user/root

# Create directory for spark history server
# mkdir -p /tmp/spark-events