#!/usr/bin/env sh

PROJECT_HOME="$(cd "$(dirname "$0")"/..; pwd)"

. $PROJECT_HOME/hack/set-default.sh

$PROJECT_HOME/sync_to_etcd.sh $1 $ETCD_CONF_PREFIX --peers="$ETCD_SERVER"
