#!/bin/env bash
dir=$1
rpcFile=$2
threads=$3
declare -i threads=$3
wallets=($(ls $dir/*.json))

totalWallets=${#wallets[@]}

runExecUrl='https://github.com/ilyasbit/solana_tools/raw/main/run.sh'
if ! [ -x "$(command -v runOre)" ]; then
  curl -L $runExecUrl -o /usr/local/bin/runOre
  chmod +x /usr/local/bin/runOre
fi

function mining {
  wallet=$1
  rpcFile=$2
  threads=$3
  for i in $(seq 1 $threads); do
    fileName=$(basename $wallet)
    echo "Mining wallet $wallet thread $i | to check the progress run: screen -r $fileName-$i"
    echo "screen -dmS $fileName-$i runOre $wallet $rpcFile"
    sleep 3
  done
}

export -f mining

parallel --delay 10 -j $totalWallets mining ::: "${wallets[@]}" $rpcFile $threads

echo "Running $totalWallets wallets with $threads threads each Done."
