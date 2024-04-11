#!/bin/env bash

wallet=$1

file=$2

#pick random rpc from file
rpc=$(shuf -n 1 $file)

while true; do
  ore --rpc $rpc --keypair $wallet --priority-fee 500000 mine --threads 4
done
