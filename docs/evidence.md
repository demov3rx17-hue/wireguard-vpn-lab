# Результаты проверок

Проверка выполнена 2026-09-01 на реальных VM.

## Handshake

На `vpn-server` команда `sudo wg show` отображает оба peer, `latest handshake`
меньше двух минут и ненулевые `transfer` counters.

## Client01: split tunnel

```text
client01 VPN address: 10.50.0.2/24
ping 10.50.0.1       -> 2/2 received
ping 192.168.20.10   -> 2/2 received
ip route get 8.8.8.8 -> via 192.168.239.2 dev ens33
traceroute 8.8.8.8   -> first hop 192.168.239.2
```

## Client02: full tunnel

```text
client02 VPN address: 10.50.0.3/24
ping 10.50.0.1       -> 2/2 received
ping 192.168.20.10   -> 2/2 received
ping 8.8.8.8         -> 2/2 received
ip route get 8.8.8.8 -> dev wg0 table 51820 src 10.50.0.3
traceroute 8.8.8.8   -> 10.50.0.1, then 192.168.239.2
```

`iptables -t nat -L POSTROUTING -v -n` на сервере показывает ненулевой
счётчик MASQUERADE для `10.50.0.0/24`.

В этой лаборатории все WAN-VM подключены к одному VMware NAT. Поэтому внешний
публичный IP через `curl` совпадает у клиентов; доказательством full tunnel
служат policy route, первый hop `10.50.0.1` и NAT-счётчик VPN-сервера.

## Troubleshooting: реальные тесты

| Сценарий | Симптом | Восстановление |
| --- | --- | --- |
| Убран `192.168.20.0/24` из AllowedIPs client01 | `ping` вернул `Required key not available` и `Destination Host Unreachable` | `systemctl restart wg-quick@wg0` вернул рабочий конфиг |
| UDP 51820 заблокирован и peer удалён из runtime | `ping 10.50.0.1` — 100% packet loss | restart `wg-quick@wg0` и повторное применение firewall |
| `net.ipv4.ip_forward=0` | клиент не видит `192.168.20.10` при активном туннеле | `sysctl -w net.ipv4.ip_forward=1` |
| Удалён MASQUERADE | client02 не пингует `8.8.8.8` | `wg-firewall-rules.sh` вернул NAT |
