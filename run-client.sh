#!/bin/bash

COMMAND='cargo run --release -- --trial --verbosity 2'

for word in $*;
do
  COMMAND="${COMMAND} ${word}"
done

function exit_node()
{
    echo "Exiting..."
    kill $!
    exit
}

trap exit_node SIGINT

echo "Running client node..."
$COMMAND &

while :
do
  echo "Checking for updates..."
  git stash
  rm Cargo.lock
  STATUS=$(git pull)

  echo "Running the client node..."
  
  if [ "$STATUS" != "Already up to date." ]; then
    cargo clean
    $COMMAND; kill -INT $!
  else
    echo "==============NO UPDATE NECESSARY, CONTINUING....================" fi

  sleep 30

done
