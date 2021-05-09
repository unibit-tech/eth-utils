#!/usr/bin/env bash

# transfer
# to: CB03e0de03c787f78f2C348FCd1F9621E309cA1F
# amount: 22000000000
# Input encoded: 0xa9059cbb000000000000000000000000cb03e0de03c787f78f2c348fcd1f9621e309ca1f000000000000000000000000000000000000000000000000000000051f4d5c00

command -v curl >/dev/null || { echo "Command 'curl' not found in \$PATH. Please, first install it." >&2; exit 1; }
command -v sed >/dev/null || { echo "Command 'sed' not found in \$PATH. Please, first install it." >&2; exit 1; }
command -v wait4ports >/dev/null || { echo "Command 'wait4ports' not found in \$PATH. Please, first install it." >&2; exit 1; }

NODE_HOST=${ETH_NODE_HOST:-localhost:8545}
OWNER_ADDR=${CONTRACT_OWNER_ADDR:-}
ADDRESS_FILE_PATH=${CONTRACT_ADDRESS_PATH}
LIST_ADDRESSES_TO_FUND=${ETH_LIST_ADDRESSES_TO_FUND:-}

if [ -z "${OWNER_ADDR}" ]; then
  echo "Missing CONTRACT_OWNER_ADDR env."
  exit 1
fi

if [ -z "${ADDRESS_FILE_PATH}" ]; then
  echo "Missing CONTRACT_ADDRESS_PATH env."
  exit 1
fi

CONTRACT_ADDR=`cat ${ADDRESS_FILE_PATH}`

PREFIX="a9059cbb000000000000000000000000"
SUFFIX="000000000000000000000000000000000000000000000000000000051f4d5c00"

GAS_IN_HEX="0x47B760"

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

if [ ! -z "${LIST_ADDRESSES_TO_FUND}" ]; then
  IFS="," read -ra LIST_ADDRESSES_TO_FUND_ARRAY <<< "${LIST_ADDRESSES_TO_FUND}"
fi

# Pre-fund all listed addresses
for ADDRESS in "${LIST_ADDRESSES_TO_FUND_ARRAY[@]}";
do

  ADDRESS=`echo "${ADDRESS}" | sed -e 's/^0x//'`
  CONTRACT_INPUT="0x${PREFIX}${ADDRESS}${SUFFIX}"
  CURL_DATA_REQUEST="{\"method\":\"eth_sendTransaction\",\"params\":[{\"from\":\"${OWNER_ADDR}\",\"to\":\"${CONTRACT_ADDR}\",\"gas\":\"${GAS_IN_HEX}\",\"data\":\"${CONTRACT_INPUT:-}\"}],\"id\":1,\"jsonrpc\":\"2.0\"}"

  echo "OWNER_ADDR=${OWNER_ADDR}"
  echo "ADDRESS=${ADDRESS}"
  echo "GAS_IN_HEX=${GAS_IN_HEX}"
  echo "CONTRACT_ADDR=${CONTRACT_ADDR}"
  echo "CONTRACT_INPUT=${CONTRACT_INPUT}"
  echo "CURL_DATA_REQUEST=${CURL_DATA_REQUEST}"

  TX_SEND_RESULT=`curl -s \
    --data "${CURL_DATA_REQUEST}" \
    -H "Content-Type: application/json" \
    -X "POST" \
    ${NODE_HOST}`

  echo "Result of eth_sendTransaction:"
  echo "${TX_SEND_RESULT}"

  sleep 1
done
