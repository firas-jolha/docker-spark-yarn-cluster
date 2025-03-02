#!/bin/bash

# VARIABLES
IMG_NAME="spark-hadoop-cluster"
HOST_PREFIX="cluster"
NETWORK_NAME=$HOST_PREFIX

N=${1:-2}
NET_QUERY=$(docker network ls | grep -i $NETWORK_NAME)
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
	docker run --name $HADOOP_SLAVE -h $HADOOP_SLAVE --net=$NETWORK_NAME -itd "$IMG_NAME"
	i=$(( $i + 1 ))
done

# START HADOOP MASTER

HADOOP_MASTER="$HOST_PREFIX"-master
docker run --name $HADOOP_MASTER -h $HADOOP_MASTER --net=$NETWORK_NAME \
		-p  8088:8088  \
		-p  8080:8080 \
		-p 8042:8042 \
		-p 4040:4040 \
		-p 4041:4041 \
		-v "$PWD/app":"/app" \
		-itd "$IMG_NAME"
		# -p 5070:50070 \
		# -p 5090:50090 \
# -p 50070:50070 -p 50090:50090 

# START MULTI-NODES CLUSTER
docker exec -it $HADOOP_MASTER "/usr/local/hadoop/start-services.sh"






