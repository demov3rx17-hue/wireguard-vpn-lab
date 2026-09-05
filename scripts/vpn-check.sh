#!/usr/bin/env bash
set -Eeuo pipefail

VPN_SERVER="${VPN_SERVER:-10.50.0.1}"
INTERNAL_SERVER="${INTERNAL_SERVER:-192.168.20.10}"

echo '== Addresses =='
ip -br addr
echo
echo '== Routes =='
ip route
echo
echo '== WireGuard =='
sudo wg show
echo
echo '== VPN server =='
ping -c 2 -W 2 "$VPN_SERVER"
echo
echo '== Internal server =='
ping -c 2 -W 2 "$INTERNAL_SERVER"
