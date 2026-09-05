#!/usr/bin/env bash
# Run as root on vpn-server. Saves firewall rules through netfilter-persistent.
set -Eeuo pipefail

WAN_IF="${WAN_IF:-ens33}"
LAN_IF="${LAN_IF:-ens34}"
VPN_IF="${VPN_IF:-wg0}"
WAN_NET="${WAN_NET:-192.168.239.0/24}"
VPN_NET="${VPN_NET:-10.50.0.0/24}"
LAN_NET="${LAN_NET:-192.168.20.0/24}"

iptables -F
iptables -t nat -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -s "$WAN_NET" -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -s "$WAN_NET" -p icmp -j ACCEPT
iptables -A INPUT -p udp --dport 51820 -j ACCEPT
iptables -A INPUT -i "$VPN_IF" -s "$VPN_NET" -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i "$VPN_IF" -s "$VPN_NET" -p icmp -j ACCEPT

iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i "$VPN_IF" -o "$LAN_IF" -d "$LAN_NET" -j ACCEPT
iptables -A FORWARD -i "$LAN_IF" -o "$VPN_IF" -s "$LAN_NET" -d "$VPN_NET" -j ACCEPT
iptables -A FORWARD -i "$VPN_IF" -o "$WAN_IF" -j ACCEPT
iptables -A FORWARD -i "$WAN_IF" -o "$VPN_IF" -d "$VPN_NET" -j ACCEPT
iptables -t nat -A POSTROUTING -s "$VPN_NET" -o "$WAN_IF" -j MASQUERADE

netfilter-persistent save
