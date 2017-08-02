#!/usr/bin/env bash

if docker ps --format '"{{".Names"}}"' | grep 'my-cassandra' ]; then
    echo 'container already running';
else
    docker run --name my-cassandra -d
    -e CASSANDRA_BROADCAST_ADDRESS={{ config.listen_address }}
    -e CASSANDRA_RPC_ADDRESS=
    -e CASSANDRA_SEEDS='{{ config.seeds }}'
    -e CASSANDRA_CLUSTER_NAME={{ config.cluster_name }}
    -e CASSANDRA_NUM_TOKENS=32
    -p 7000:7000
    -p 7001:7001
    -p 7199:7199
    -p 9042:9042
    cassandra:3.11.0;
fi

