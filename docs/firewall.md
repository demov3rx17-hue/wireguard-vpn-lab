# Firewall и NAT

На `vpn-server` используются постоянные правила `iptables` через
`netfilter-persistent`.

- INPUT и FORWARD имеют политику `DROP`;
- разрешены established/related;
- SSH разрешён из доверенной сети VMnet8 (`192.168.239.0/24`);
- разрешен UDP `51820`;
- с VPN разрешены SSH и ICMP к VPN-серверу;
- разрешен forwarding `wg0 -> ens34` к `192.168.20.0/24`;
- разрешен forwarding `wg0 -> ens33` для full tunnel;
- NAT: `10.50.0.0/24 -> ens33` (MASQUERADE).

Рабочий скрипт: [../firewall/rules.sh](../firewall/rules.sh).
