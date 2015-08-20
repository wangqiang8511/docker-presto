# Facebook Presto

Simple docker images for presto.

Using etcd to sync catalog configs and register discovery.uri.

# How to use

## Build Image

```bash
./build
```

## Config

Modify hack/set-default.sh.tmpl

## Run

```bash
# Do change the catalog config in etc folder
# Sync the config in etcd 
hack/sync_config.sh your_etc_folder etcd_key

# Start coordinator
hack/start_presto_coordinator.sh

# Start worker
hack/start_presto_worker.sh
```

## Reference
[presto](https://prestodb.io/docs/current/index.html)
