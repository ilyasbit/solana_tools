#!/bin/bash
dir=$1
rpcFile=$2
wallets=($(ls $dir/*.json))
totalWallets=${#wallets[@]}

function claimOre() {
  wallet=$1
  rpcFile=$2
  rpc=$(shuf -n 1 $rpcFile)
  baseBalance=0
  oreBalance=$(ore --keypair $wallet balance --rpc $rpc | cut -d' ' -f1)
  oreBalance="$(echo "scale=8; $baseBalance + $oreBalance" | bc)"
  keypairFile=$(basename $wallet)
  echo "claiming $keypairFile reward"
  while true; do
    pids=()
    for i in {1..5}; do
      ore --keypair $wallet claim --rpc $rpc --priority-fee 500000 >/dev/null &
      pids+=($!)
    done
    for pid in ${pids[@]}; do
      wait $pid
    done
    currentBalance=$(ore --keypair $wallet balance --rpc $rpc | cut -d' ' -f1)
    #compare balance before and after claim
    if [ "$oreBalance" != "$currentBalance" ]; then
      echo "$keypairFile | claimed, current Balance $currentBalance ORE"
      return
    fi
  done
}

export -f claimOre

echo "Start claim ORE"
claimPids=()
for wallet in "${wallets[@]}"; do
  claimOre $wallet $rpcFile &
  claimPids+=($!)
done

for pid in ${claimPids[@]}; do
  wait $pid
done

echo "All claims successful"
