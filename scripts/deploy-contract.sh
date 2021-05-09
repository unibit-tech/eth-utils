#!/usr/bin/env sh

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 contract-file (from contracts)" >&1
  exit 1
fi

CURRENT_DIR=$PWD

docker build ./docker/geth/ -t geth

# we need to first compile the contract & then put the .abi file in the contracts volume
# TODO: change the local geth image to an image from Github Packages (or other custom Synapsics registry)
docker run \
    -w /root \
    --network=docker_local_eth_utils \
    -v docker_contract-assets-dir:/root/contracts/ \
    -v $CURRENT_DIR/contracts/"$1".sol:/root/contracts/"$1".sol:ro \
    -v $CURRENT_DIR/scripts/contract-compile-solc.sh:/root/contract-compile-solc.sh:ro \
    -e "CONTRACT_FILE_PATH=/root/contracts/$1.sol" \
    -e "CONTRACT_OUTPUT_PATH=/root/contracts/$1" \
    --entrypoint "/bin/sh" \
    ethereum/solc:0.5.16-alpine contract-compile-solc.sh

docker run \
    -w /root \
    --network=docker_local_eth_utils \
    -v docker_contract-assets-dir:/root/contracts/ \
    -v $CURRENT_DIR/scripts/contract-deploy-eth.sh:/root/contract-deploy-eth.sh:ro \
    -e "CONTRACT_BIN_FILE_PATH=/root/contracts/$1/$1.bin" \
    -e "WAIT_FOR_CONTRACT_BIN_FILE_PATH=true" \
    -e "CONTRACT_NAME=$1" \
    -e "CONTRACT_ARGS=" \
    -e "CONTRACT_OWNER_ADDR=0xe022cfD8c97a67c298729200E1Ee3381E8f16547" \
    -e "CONTRACT_ADDRESS_OUTPUT_PATH=/root/contracts/$1/$1-address.txt" \
    -e "ETH_NODE_HOST=geth-bootstrap:22222" \
    --entrypoint="/bin/sh" \
    geth contract-deploy-eth.sh
