#!/bin/bash

COMMAND='cargo run --release -- --trial --verbosity 2'

for word in $*;
do
  COMMAND="${COMMAND} ${word}"
done

function exit_node()
{
    echo "Exiting..."
    kill $(cat /tmp/snarkos-client.pid)
    exit
}

trap exit_node SIGINT

echo "Running client node..."
$COMMAND & 
echo $! > /tmp/snarkos-client.pid

while :
do
  echo "Checking for updates..."
  git stash
  rm Cargo.lock


  echo "Running the snarkos client node..."
  
  STATUS=$(git pull)
  if [ "$STATUS" != "Already up to date." ]; then
    cargo clean
    $COMMAND; kill -INT $(cat /tmp/snarkos-client.pid)
  else
    echo "==============NO UPDATE NECESSARY, CONTINUING....================"
  fi

  sleep 30

done
