#!/bin/bash

# One function etcdctl may missing

target=$1
shift
prefix=$1
shift

while [ "$1" != "" ]; do
    PARAM=$(echo $1 | awk -F= '{print $1}')    
    VALUE=$(echo $1 | awk -F= '{print $2}')    
    case $PARAM in
        -p | --peers)
            peers=$VALUE
            ;;
    esac
    shift
done

peers=${peers:-http://localhost:4001}

function sync_file() {
    etcdctl --peers="$peers" get $1 > $2
}

function sync_folder() {
    rm -f $2
    mkdir -p $2
    for i in $(etcdctl --peers="$peers" ls $1)
    do
	sync_file $i $2/$(basename $i)
	if [ $? -eq 1 ]; then
	    sync_folder $i $2/$(basename $i)
        fi
    done
}


sync_file $target $prefix
if [ $? -eq 1 ]; then
    sync_folder $target $prefix
fi
