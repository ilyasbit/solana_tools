#!/bin/env bash

#rpc='http://localhost:8799'
dir=$1
keypairs=($(ls $dir/*.json))

totalReward=0
for keypair in "${keypairs[@]}"; do
  reward=$(ore --keypair $keypair rewards)
  echo "key: $keypair reward: $reward"
  reward=$(echo $reward | cut -d ' ' -f1)
  totalReward="0$(echo "scale=8; $totalReward + $reward" | bc)"
done
time=$(date)
echo "Total reward: $totalReward ORE at $time"
