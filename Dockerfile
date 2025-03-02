# FROM ubuntu:16.04
FROM ubuntu:20.04
# ubuntu Focal Fossa

# Run the next commands as root user
USER root

# install jfk and other tools
RUN apt-get update && \
 apt-get -y dist-upgrade && \
 apt-get install -y openssh-server \ 
 default-jdk wget scala openjdk-8-jdk \ 
 net-tools iputils-ping curl

RUN  apt-get -y update
# install zip tool
RUN  apt-get -y install zip 
# install vim tool
RUN  apt-get -y install vim

# set environment variable 
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Create ssh key and exchange it with the container
RUN ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -P "" \
    && cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys 
    # \
    # && 

# set spark and hadoop versions
ENV SPARK_VERSION=3.5.4
ENV HADOOP_VERSION=3.3.1

#  download hadoop and unzip
RUN wget -O /hadoop.tar.gz http://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz \
    && tar xfz hadoop.tar.gz \
    && mv /hadoop-$HADOOP_VERSION /usr/local/hadoop \
    && rm /hadoop.tar.gz

# download spark and unzip
RUN wget -O /spark.tar.gz https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz
RUN tar xfz spark.tar.gz
RUN mv /spark-$SPARK_VERSION-bin-hadoop3 /usr/local/spark
RUN rm /spark.tar.gz


# set home directory for hadoop and spark
ENV HADOOP_HOME=/usr/local/hadoop
ENV SPARK_HOME=/usr/local/spark
# add binaries of hadoop and spark to system path
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME:sbin

# create directories for storing data in namenode and datanode
RUN mkdir -p $HADOOP_HOME/hdfs/namenode \
    && mkdir -p $HADOOP_HOME/hdfs/datanode

# copy the custom configs
COPY config/ /tmp/
RUN mv /tmp/ssh_config $HOME/.ssh/config \
    && mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh \
    && mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml \
    && mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml \
    && mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml.template \
    && cp $HADOOP_HOME/etc/hadoop/mapred-site.xml.template $HADOOP_HOME/etc/hadoop/mapred-site.xml \
    && mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml \
    && cp /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves \
    && cp /tmp/workers $HADOOP_HOME/etc/hadoop/workers \
    && mv /tmp/slaves $SPARK_HOME/conf/slaves \
    && mv /tmp/spark/spark-env.sh $SPARK_HOME/conf/spark-env.sh \
    && mv /tmp/spark/log4j.properties $SPARK_HOME/conf/log4j.properties \
    && mv /tmp/spark/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf

# copy the script to the container
ADD scripts/start-services.sh $HADOOP_HOME/start-services.sh

# Change permissions of Hadoop
RUN chmod 744 -R $HADOOP_HOME

# Formatting the HDFS by the namenode
RUN $HADOOP_HOME/bin/hdfs namenode -format

# Expose some ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
EXPOSE 10020 19888
EXPOSE 8030 8031 8032 8033 8040 8042 8088
EXPOSE 49707 2122 7001 7002 7003 7004 7005 7006 7007 8888 9000

# create a custom directory for my Spark app
RUN mkdir -p /app

# Entry point for my container
SHELL ["/bin/bash", "-c"]

ENTRYPOINT service ssh start;cd ${SPARK_HOME};bash

