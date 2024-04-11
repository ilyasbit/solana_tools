#!/bin/env bash

apt update && apt upgrade -y
apt install parallel jq -y
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env"
cargo install ore-cli

