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
    cat $1 | etcdctl --peers="$peers" set $2
}

function sync_folder() {
    etcdctl --peers="$peers" mkdir $2
    for i in $(ls $1)
    do
	if [ -d $1/$i ]; then
            sync_folder $1/$i $2/$i
	else
            sync_file $1/$i $2/$i
        fi
    done
}


if [ -d $target ]; then
    sync_folder $target $prefix
else
    sync_file $target $prefix
fi
