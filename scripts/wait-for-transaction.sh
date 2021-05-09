#!/usr/bin/env sh

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 NODE TX" >&2
  exit 1
fi

NODE_HOST=$1
TX_HASH=$2

wait4ports tcp://${NODE_HOST}

if [ -z "${TX_HASH}" ]; then
  echo "Could not get the tx hash."
  exit 1
fi

TX_GET_RECEIPT_RESULT="null"
while [[ "${TX_GET_RECEIPT_RESULT}" == "null" || "${TX_GET_RECEIPT_RESULT}" == "" ]] ; do
  echo "waiting for the transaction hash (${TX_HASH}) to be available..."

  TX_GET_RECEIPT=`curl -s \
    --data "{\"method\":\"eth_getTransactionReceipt\",\"params\":[\"${TX_HASH}\"],\"id\":1,\"jsonrpc\":\"2.0\"}" \
    -H "Content-Type: application/json" \
    -X "POST" \
    "${NODE_HOST}"`

  echo ${TX_GET_RECEIPT}
  TX_GET_RECEIPT_RESULT=`echo ${TX_GET_RECEIPT} | jq -r '.result'`

  sleep 3
done