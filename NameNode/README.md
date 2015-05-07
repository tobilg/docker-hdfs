# Apache Hadoop (v2.6) HDFS NameNode

A Docker instance containing a Apache Hadoop HDFS NameNode.

### Running

Execute the following on your Docker host (make sure the volumes exist):

```
$ docker run \
    --name namenode \
    --net=host \
    -d \
    -e HDFS_HOSTS=hostname1,hostname2,hostname3 \
    -v /data/dfs/namenode:/data/dfs/nn \
    -v /data/dfs/datanode/1:/data/dfs/dn \
    tobilg/hdfs-namenode
```

The NameNode listens on port 9000 by default.