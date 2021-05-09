#!/usr/bin/env sh

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 FILE" >&2
  exit 1
fi

while [ ! -f $1 ]; do
  sleep 5
  echo "waiting file $1 to become available..."
done