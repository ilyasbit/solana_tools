#!/bin/bash

myNode="http://127.0.0.1:8899"

getSlot() {
    local newUrl=$1
    local checkSlot=$(curl -s $newUrl -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getSlot"}')
    local slot=$(echo $checkSlot | jq -r '.result')
    echo $slot
}

checkMyNodeIsConnectedRefused() {
    local newUrl=$1
    local checkSlot=$(curl -s $newUrl -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getSlot"}')
    local slot=$(echo $checkSlot | jq -r '.result')
    if [ "$slot" == "null" ]; then
        echo "[-] Your node is not connected to the network"
        exit 1
    fi
}

checkIfJqInstalled() {
    if ! [ -x "$(command -v jq)" ]; then
        echo "[-] jq isnt installed. installing for you..." 
        sudo apt-get install jq -y
    fi
}

checkIsRoot() {
    if [ "$EUID" -ne 0 ]; then
        echo "[-] Please run as root"
        exit 1
    fi
}

checkIsRoot
checkIfJqInstalled


checkMyNodeIsConnectedRefused $myNode

officialNode="https://api.mainnet-beta.solana.com"
printf "[+] Check Diff Slot Mainnet Solana and Your NODE\n"
printf "Your Node : $myNode\n"
printf "Official Node : $officialNode\n"
printf "\n"

declare -i slotMy=$(getSlot $myNode)
declare -i slotOf=$(getSlot $officialNode)
diffSlot=$(($slotOf - $slotMy))

printf "Official Slot : $slotOf\n"
printf "Your Slot : $slotMy\n"
printf "Diff Slot : $diffSlot\n"
