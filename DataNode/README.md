# Apache Hadoop (v2.6) HDFS DataNode

A Docker instance containing a Apache Hadoop HDFS DataNode.

### Running

Execute the following on your Docker host (make sure the volumes exist):

```
$ docker run \
    --name namenode \
    --net=host \
    -d \
    -e HDFS_HOSTS=hostname1,hostname2,hostname3 \
    -e NAMENODE=namenode_hostname
    -v /data/dfs/datanode/2:/data/dfs/dn \
    tobilg/hdfs-datanode
}'
```