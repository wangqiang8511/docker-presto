#!/usr/bin/env sh

PROJECT_HOME="$(cd "$(dirname "$0")"/..; pwd)"

. $PROJECT_HOME/hack/set-default.sh

docker run -d \
	-e CLUSTER_NAME=$CLUSTER_NAME \
	-e ETCD_SERVER=$ETCD_SERVER \
	-e ETCD_CONF_PREFIX=$ETCD_CONF_PREFIX \
        $IMAGE \
        /scripts/setup.sh worker
