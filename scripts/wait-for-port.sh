#!/usr/bin/env sh

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 HOST PORT" >&2
  exit 1
fi

command -v nc >/dev/null || { echo "Command 'nc' not found in \$PATH. Please, first install it." >&2; exit 1; }

while ! nc -z $1 $2; do
  sleep 1
  echo "waiting $1:$2 to become available..."
done