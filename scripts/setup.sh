#!/bin/bash

CLUSTER_NAME=${CLUSTER_NAME:-test}

if [ -n "$1" ]; then
    INSTANCE_TYPE=$1
else
    INSTANCE_TYPE=combo
fi

# Get the config from etcd
if [ -z "$ETCD_SERVER" ]; then
    INSTANCE_TYPE=combo
fi

ETCD_CONF_PREFIX=${ETCD_CONF_PREFIX:-/presto/conf/test}
/sync_from_etcd.sh $ETCD_CONF_PREFIX $PRESTO_HOME/etc --peers=$ETCD_SERVER


DISCOVERY_PORT=${DISCOVERY_PORT:-8080}
sed -i 's;HOSTNAME;'$(hostname -f)';g' $PRESTO_HOME/etc/node.properties
cp $PRESTO_HOME/etc/${INSTANCE_TYPE}_config.properties $PRESTO_HOME/etc/config.properties
sed -i 's;DISCOVERY_PORT;'$DISCOVERY_PORT';g' $PRESTO_HOME/etc/config.properties

if [ "$INSTANCE_TYPE" != "worker" ]; then
    HOST=${HOST:-$(hostname -i)}
    PORT0=${PORT0:-$DISCOVERY_PORT}
    DISCOVERY_URL=http://$HOST:$PORT0
    etcdctl --peers=$ETCD_SERVER mkdir $ETCD_CONF_PREFIX/$CLUSTER_NAME $DISCOVERY_URL
    etcdctl --peers=$ETCD_SERVER set $ETCD_CONF_PREFIX/$CLUSTER_NAME/discovery_uri $DISCOVERY_URL
    sed -i 's;DISCOVERY_URL;'$DISCOVERY_URL';g' $PRESTO_HOME/etc/config.properties
else 
    DISCOVERY_URL=$(etcdctl --peers=$ETCD_SERVER get $ETCD_CONF_PREFIX/$CLUSTER_NAME/discovery_uri)
    sed -i 's;DISCOVERY_URL;'$DISCOVERY_URL';g' $PRESTO_HOME/etc/config.properties
fi

$PRESTO_HOME/bin/launcher run 
