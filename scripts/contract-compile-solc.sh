#!/usr/bin/env sh

CONTRACT_FILE=${CONTRACT_FILE_PATH:-}
CONTRACT_OUTPUT=${CONTRACT_OUTPUT_PATH:-./}

if [ -z "${CONTRACT_FILE}" ]; then
  echo "Missing CONTRACT_FILE_PATH env."
  exit 1
fi

if [ ! -e ${CONTRACT_OUTPUT} ]; then
  mkdir -p ${CONTRACT_OUTPUT}
elif [ ! -d ${CONTRACT_OUTPUT} ]; then
  echo "${CONTRACT_OUTPUT} already exists but is not a directory" 1>&2
  exit 1
fi

solc -o ${CONTRACT_OUTPUT} --abi --bin ${CONTRACT_FILE} --overwrite

ls -la ${CONTRACT_OUTPUT}