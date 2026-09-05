#!/usr/bin/env bash
set -Eeuo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y wireguard curl traceroute
echo 'WireGuard and diagnostics tools installed.'
