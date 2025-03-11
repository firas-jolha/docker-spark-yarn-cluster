#!/bin/bash

# VARIABLES
IMG_NAME="spark-hadoop-cluster"
HOST_PREFIX="cluster"
NETWORK_NAME=$HOST_PREFIX

N=${1:-2}
NET_QUERY=$(docker network ls | grep -i $NETWORK_NAME)
echo $NET_QUERY
if [ -z "$NET_QUERY" ]; then
	docker network create --driver=bridge $NETWORK_NAME
fi

# Building the current image
docker build -t $IMG_NAME . 

# START HADOOP SLAVES 
i=1
while [ $i -le $N ]
do
	HADOOP_SLAVE="$HOST_PREFIX"-slave-$i
	port=$(( 9864 + $i - 1 ))
	# port_spark_worker=$(( 8081 + $i - 1 ))
	port_spark_worker=$(( 8081 + $i ))
	# echo $port
	docker run -p $port:9864 -p $port_spark_worker:8081 --name $HADOOP_SLAVE -h $HADOOP_SLAVE --net=$NETWORK_NAME -itd "$IMG_NAME"
	i=$(( $i + 1 ))
done

# START HADOOP MASTER

HADOOP_MASTER="$HOST_PREFIX"-master
docker run --name $HADOOP_MASTER -h $HADOOP_MASTER --net=$NETWORK_NAME \
		-p  8088:8088 \
		-p  8080:8080 \
		-p 8042:8042 \
		-p 4040:4040 \
		-p 4041:4041 \
		-p 9870:9870 \
		-p 9869:9868 \
		-p  18080:18080 \
		-p 19888:19888 \
		-v "$PWD/app":"/app" \
		-itd "$IMG_NAME"

# 8088: Yarn resource manager
# 8042: Yarn node manager


# 8080: Spark Master
# 4040: Spark application
# 4041: next Spark application
# 18080: Spark history server
# 8081: Spark worker

# 9000: HDFS namenode rpc port
# 9870: HDFS namenode
# 9869:9868: HDFS secondary namenode
# 9864: HDFS datanode

# 19888: Mapreduce history server

# START MULTI-NODES CLUSTER
docker exec -it $HADOOP_MASTER "/usr/local/hadoop/start-services.sh"






