#!/usr/bin/env bash

set -e

sleep 3

geth --datadir=~/.ethereum/privatenet init /root/privatenet-genesis.json

sleep 3

# Resolves the IP of 'geth-bootstrap' hostname (container).
# This is required since enode URL does not support hostnames yet
BOOTSTRAP_IP=`getent hosts geth-bootstrap | cut -d" " -f1`
GETH_OPTS=${@/XXXXXXXXX/$BOOTSTRAP_IP}

geth ${GETH_OPTS}