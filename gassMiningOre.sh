#!/bin/env bash
dir=$1
wallets=($(ls $dir/*.json))

totalWallets=${#wallets[@]}

function mining {
  wallet=$1
  for i in {1..10}; do
    fileName=$(basename $wallet)
    screen -dmS $fileName-$i ~/solcheck/run.sh $wallet
    sleep 3
  done
}

export -f mining

parallel --delay 10 -j $totalWallets mining ::: "${wallets[@]}"
