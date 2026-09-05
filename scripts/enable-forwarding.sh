#!/usr/bin/env bash
set -Eeuo pipefail
install -m 0644 /dev/stdin /etc/sysctl.d/99-wireguard-forwarding.conf <<'EOF'
net.ipv4.ip_forward=1
EOF
sysctl --system
