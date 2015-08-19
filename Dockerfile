FROM     ubuntu:14.04
MAINTAINER Wang Qiang <wangqiang8511@gmail.com>

# Last Package Update & Install
RUN apt-get update && apt-get install -y curl wget net-tools iputils-ping vim

# JDK
ENV JDK_URL http://download.oracle.com/otn-pub/java/jdk
ENV JDK_VER 8u51-b16
ENV JDK_VER2 jdk-8u51
ENV JAVA_HOME /usr/local/jdk
ENV PATH $PATH:$JAVA_HOME/bin
RUN cd $SRC_DIR && curl -LO "$JDK_URL/$JDK_VER/$JDK_VER2-linux-x64.tar.gz" -H 'Cookie: oraclelicense=accept-securebackup-cookie' \
 && tar xzf $JDK_VER2-linux-x64.tar.gz && mv jdk1* $JAVA_HOME && rm -f $JDK_VER2-linux-x64.tar.gz \
 && echo '' >> /etc/profile \
 && echo '# JDK' >> /etc/profile \
 && echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile \
 && echo 'export PATH="$PATH:$JAVA_HOME/bin"' >> /etc/profile \
 && echo '' >> /etc/profile

# Presto
ENV SRC_DIR /opt
ENV PRESTO_URL https://repo1.maven.org/maven2/com/facebook/presto/presto-server
ENV PRESTO_VERSION 0.115
RUN mkdir -p $SRC_DIR \
 && cd $SRC_DIR \
 && wget "$PRESTO_URL/$PRESTO_VERSION/presto-server-$PRESTO_VERSION.tar.gz" \
 && tar xzf presto-server-$PRESTO_VERSION.tar.gz \
 && rm -f presto-server-$PRESTO_VERSION.tar.gz

# PrestoAPI
ENV PRESTO_CLI_URL https://repo1.maven.org/maven2/com/facebook/presto/presto-cli
RUN cd $SRC_DIR \
 && wget "$PRESTO_CLI_URL/$PRESTO_VERSION/presto-cli-$PRESTO_VERSION-executable.jar" \
 && mv "presto-cli-$PRESTO_VERSION-executable.jar" presto-cli \
 && chmod +x presto-cli

# Launch program require python installed
RUN apt-get update && apt-get install -y python

ENV PRESTO_HOME $SRC_DIR/presto-server-$PRESTO_VERSION

ADD etc $PRESTO_HOME/etc
ADD scripts /scripts
ADD etcdctl /bin/etcdctl
ADD sync_from_etcd.sh /sync_from_etcd.sh
ADD sync_to_etcd.sh /sync_to_etcd.sh
