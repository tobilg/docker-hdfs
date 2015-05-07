FROM ubuntu:14.04.2
MAINTAINER tobilg <fb.tools.github@gmail.com>

# packages
RUN apt-get update && apt-get install -yq --no-install-recommends --force-yes \
    curl \
    wget \
    ca-certificates \
    dnsutils \
    screen

# java
RUN curl -LO 'http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz' -H 'Cookie: oraclelicense=accept-securebackup-cookie'
RUN tar zxf jdk-7u79-linux-x64.tar.gz
RUN mkdir -p /opt/java
RUN mv /jdk1.7.0_79 /opt/java/jdk1.7.0_79
RUN update-alternatives --install "/usr/bin/java" "java" "/opt/java/jdk1.7.0_79/bin/java" 1
RUN update-alternatives --install "/usr/bin/javac" "javac" "/opt/java/jdk1.7.0_79/bin/javac" 1
RUN update-alternatives --install "/usr/bin/javaws" "javaws" "/opt/java/jdk1.7.0_79/bin/javaws" 1
RUN update-alternatives --install "/usr/bin/jar" "jar" "/opt/java/jdk1.7.0_79/bin/jar" 1 

# set ENV variables
ENV JAVA_HOME /opt/java/jdk1.7.0_79
ENV PATH $PATH:$JAVA_HOME/bin
ENV HADOOP_VERSION=2.6.0

# add cloudera cdh repository info
RUN wget 'http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/cloudera.list' -O /etc/apt/sources.list.d/cloudera.list
RUN wget 'http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/archive.key' -O /tmp/archive.key
RUN wget 'https://gist.githubusercontent.com/tobilg/b3702f443fabbef0a357/raw/baa3adffea28b3f8c9898f329aa609098162c316/cloudera.pref' -O /etc/apt/preferences.d/cloudera.pref
RUN apt-key add /tmp/archive.key
RUN rm /tmp/archive.key

RUN groupadd -r hadoop &&\
    groupadd -r hdfs &&\
    useradd -r -d /var/lib/hadoop-hdfs -m -g hdfs -G hadoop hdfs

# install hadoop
RUN apt-get update && apt-get install -yq --no-install-recommends --force-yes \
    "hadoop-hdfs-namenode=$HADOOP_VERSION+*"

# create data dirs and change ownership
RUN mkdir -p /data/dfs/dn
RUN chown -R hdfs:hdfs /data/dfs/dn

# setup/update ntp
RUN wget 'https://gist.githubusercontent.com/tobilg/0e438775ccd20d06314a/raw/1cc4dd75383fefd0ba29d1a0fce3c8807a43583a/ntp.conf' -O /etc/ntp.conf
RUN ntpdate -s 0.pool.ntp.org

# hadoop config
ENV HADOOP_CLUSTER_NAME hdfs-cluster
ENV HADOOP_CONFIG_PATH /etc/hadoop/conf.$HADOOP_CLUSTER_NAME
RUN mkdir -p $HADOOP_CONFIG_PATH
RUN update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.$HADOOP_CLUSTER_NAME 50
RUN update-alternatives --set hadoop-conf /etc/hadoop/conf.$HADOOP_CLUSTER_NAME
ADD hdfs-site.xml $HADOOP_CONFIG_PATH/hdfs-site.xml
ADD core-site.xml.template $HADOOP_CONFIG_PATH/core-site.xml.template

ENV HADOOP_PREFIX /usr/lib/hadoop

# cleanup
RUN apt-get clean && \
    rm -rf /tmp/* /var/tmp/* jdk-7u79-linux-x64.tar.gz

EXPOSE 50010 50020 50075

COPY bootstrap.sh /
RUN chmod +x /bootstrap.sh

ENTRYPOINT ["/bootstrap.sh"]

VOLUME /data/dfs /etc/hadoop