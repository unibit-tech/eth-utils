#!/usr/bin/env sh

command -v curl >/dev/null || { echo "Command 'curl' not found in \$PATH. Please, first install it." >&2; exit 1; }
command -v jq >/dev/null || { echo "Command 'jq' not found in \$PATH. Please, first install it." >&2; exit 1; }
command -v wait4ports >/dev/null || { echo "Command 'wait4ports' not found in \$PATH. Please, first install it." >&2; exit 1; }

NODE_HOST=${ETH_NODE_HOST:-localhost:8545}

OWNER_ADDR=${CONTRACT_OWNER_ADDR:-}

if [ -z "${OWNER_ADDR}" ]; then
  echo "Missing CONTRACT_OWNER_ADDR env."
  exit 1
fi

CONTRACT_BIN_FILE=${CONTRACT_BIN_FILE_PATH:-}

if [ -z "${CONTRACT_BIN_FILE}" ]; then
  echo "Missing CONTRACT_BIN_FILE_PATH env."
  exit 1
fi


NAME=${CONTRACT_NAME:-Contract}
ADDR_OUTPUT_PATH=${CONTRACT_ADDRESS_OUTPUT_PATH:-./${NAME}-address.txt}

TX_SEND_RESULT_PATH=${CONTRACT_TX_SEND_RESULT_PATH:-./${NAME}-tx-send-result.txt}
TX_GET_RECEIPT_PATH=${CONTRACT_TX_GET_RECEIPT_PATH:-./${NAME}-tx-get-receipt.txt}

CONTRACT_BIN=`cat ${CONTRACT_BIN_FILE}`
CONTRACT_BIN_AND_ARGS=${CONTRACT_BIN}${CONTRACT_ARGS:-}

WAIT_FOR_BIN_FILE=${WAIT_FOR_CONTRACT_BIN_FILE_PATH:-false}

if [ "${WAIT_FOR_BIN_FILE}" = true ]; then
  while [ ! -f ${CONTRACT_BIN_FILE} ]; do
    echo "waiting ${CONTRACT_BIN_FILE} to become available..."
    sleep 5
  done
fi

wait4ports tcp://${NODE_HOST}

# wait unlock account is unlocked (the first one in the array!)
while [ "${ACCOUNT_STATUS}" != "Unlocked" ]; do
  echo "waiting account to be unlocked on ${NODE_HOST} to become available..."
  ACCOUNT_STATUS=`curl -s \
      --data "{\"method\":\"personal_listWallets\",\"params\":[],\"id\":1,\"jsonrpc\":\"2.0\"}" \
      -H "Content-Type: application/json" \
      -X "POST" \
      ${NODE_HOST} \
      | jq -r '.result[0] .status'`
  echo "ACCOUNT_STATUS=${ACCOUNT_STATUS}"
  sleep 5
done

# I discovered that we need to wait for something else just than
# waiting for the account to be unlocked... the reason is that, sometimes,
# the USDT contract is not available even after the tx is sent to the network.
# Probably, we need to check if the node is syncing already before the "eth_sendTransaction"
# below.
BLOCK_NUMBER=0
while [ "${BLOCK_NUMBER}" -lt "10" ]; do
  echo "waiting until some blocks are generated..."
  BLOCK_NUMBER_HEX=`curl -s \
      --data "{\"method\":\"eth_blockNumber\",\"params\":[],\"id\":1,\"jsonrpc\":\"2.0\"}" \
      -H "Content-Type: application/json" \
      -X "POST" \
      ${NODE_HOST} \
      | jq -r '.result'`
  BLOCK_NUMBER=`printf "%d" ${BLOCK_NUMBER_HEX}`
  echo "BLOCK_NUMBER=${BLOCK_NUMBER}"
  sleep 5
done


echo "Deploying contract to host '${NODE_HOST}'..."
echo "OWNER_ADDR=${OWNER_ADDR}"
echo "CONTRACT_BIN_FILE=${CONTRACT_BIN_FILE}"
echo "NAME=${NAME}"
echo "TX_SEND_RESULT_PATH=${TX_SEND_RESULT_PATH}"
echo "TX_GET_RECEIPT_PATH=${TX_GET_RECEIPT_PATH}"
echo "CONTRACT_BIN=${CONTRACT_BIN}"
echo "CONTRACT_ARGS=${CONTRACT_ARGS}"

curl -s \
  --data "{\"method\":\"eth_sendTransaction\",\"params\":[{\"from\":\"${OWNER_ADDR}\",\"gas\":\"0x47B760\",\"data\":\"0x${CONTRACT_BIN_AND_ARGS}\"}],\"id\":1,\"jsonrpc\":\"2.0\"}" \
  -H "Content-Type: application/json" \
  -X "POST" \
  ${NODE_HOST} > ${TX_SEND_RESULT_PATH}

echo "Deployment response:"
cat ${TX_SEND_RESULT_PATH}

# parse the TX_SEND_RESULT_PATH and get "result"
TX_RECEIPT_HASH=`cat ${TX_SEND_RESULT_PATH} | jq -r '.result'`

if [ -z "${TX_RECEIPT_HASH}" ]; then
  echo "Could not parse the Tx Receipt Result. Missing TX_RECEIPT_HASH var."
  exit 1
fi

while [[ "${TX_GET_RECEIPT_RESULT}" == "null" || "${TX_GET_RECEIPT_RESULT}" == "" ]] ; do

  echo "waiting for the transaction hash (${TX_RECEIPT_HASH}) to be available..."

  curl -s \
    --data "{\"method\":\"eth_getTransactionReceipt\",\"params\":[\"${TX_RECEIPT_HASH}\"],\"id\":1,\"jsonrpc\":\"2.0\"}" \
    -H "Content-Type: application/json" \
    -X "POST" \
    ${NODE_HOST} > ${TX_GET_RECEIPT_PATH}

  cat ${TX_GET_RECEIPT_PATH}

  TX_GET_RECEIPT_RESULT=`cat ${TX_GET_RECEIPT_PATH} | jq -r '.result'`

  sleep 3

done

if [ ! -z "${TX_GET_RECEIPT_RESULT}" ] && [ "${TX_GET_RECEIPT_RESULT}" != "null" ]  ; then
  CONTRACT_ADDR=`echo ${TX_GET_RECEIPT_RESULT} | jq -r '.contractAddress'`
  echo "Contract address is: ${CONTRACT_ADDR}"
  echo "Saving contract address to ${ADDR_OUTPUT_PATH}"
  echo "${CONTRACT_ADDR}" > ${ADDR_OUTPUT_PATH}
fi
