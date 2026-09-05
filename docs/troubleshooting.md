# Troubleshooting

| Неисправность | Симптом | Диагностика | Исправление |
| --- | --- | --- | --- |
| Неправильный `AllowedIPs` | нет маршрута к `192.168.20.10` | `ip route`, `wg show` | добавить `192.168.20.0/24` для split tunnel или `0.0.0.0/0` для full tunnel |
| Заблокирован UDP 51820 | handshake отсутствует | `ss -lunp`, `tcpdump -ni any port 51820`, `wg show` | разрешить UDP 51820 firewall |
| Выключен forwarding | handshake есть, LAN недоступна | `sysctl net.ipv4.ip_forward`, `ping 192.168.20.10` | включить `net.ipv4.ip_forward=1` |
| Удалён NAT | full tunnel не выходит в интернет | `iptables -t nat -L -v`, `curl`, `traceroute` | вернуть MASQUERADE из VPN-сети в WAN |

Перед искусственным изменением конфигурации сделай резервную копию:

```bash
sudo cp /etc/wireguard/wg0.conf /etc/wireguard/wg0.conf.bak
sudo iptables-save > ~/iptables-before-test.rules
```

Все четыре сценария были реально выполнены и после каждого рабочая
конфигурация была восстановлена. Краткие фактические результаты находятся в
[evidence.md](evidence.md).
