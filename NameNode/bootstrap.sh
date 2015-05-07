#!/bin/bash

if [ -n "${HDFS_HOSTS+1}" ]; then
  IFS=',' read -a hdfshosts <<< "$HDFS_HOSTS"
  for index in "${!hdfshosts[@]}"
  do
    echo "`nslookup ${hdfshosts[index]} | tail -2 | head -1 | awk '{print $2}'`   ${hdfshosts[index]}"  >> /etc/hosts
  done
fi

if [ -n "${HOSTNAME+1}" ]; then
    sed s/HOSTNAME/"${HOSTNAME}"/ $HADOOP_CONFIG_PATH/core-site.xml.template > $HADOOP_CONFIG_PATH/core-site.xml
    rm $HADOOP_CONFIG_PATH/core-site.xml.template
else 
    mv $HADOOP_CONFIG_PATH/core-site.xml.template $HADOOP_CONFIG_PATH/core-site.xml
fi

# start NameNode
screen -dm hdfs namenode

# start DataNode
screen -dm hdfs datanode

if [[ $1 == "bash" ]]; then
  exec /bin/bash
else
  while true; do sleep 1000; done
fi