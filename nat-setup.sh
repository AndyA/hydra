#!/bin/bash

ip rule add fwmark 2 table 12 
ip rule add fwmark 3 table 13 
ip route add default dev wlan1 table 12
ip route add default dev wlan2 table 13
ip route add 10.70.2.0/24 dev wlan1
ip route add 10.70.3.0/24 dev wlan2
ip route flush cache
iptables -t mangle -A OUTPUT -d 10.70.2.0/24 -j MARK --set-mark 2
iptables -t mangle -A OUTPUT -d 10.70.3.0/24 -j MARK --set-mark 3
iptables -t nat -A POSTROUTING -o wlan1 -j NETMAP --to 10.5.5.0/24
iptables -t nat -A POSTROUTING -o wlan2 -j NETMAP --to 10.5.5.0/24
iptables -t nat -A OUTPUT -o wlan1 -j NETMAP --to 10.5.5.0/24
iptables -t nat -A OUTPUT -o wlan2 -j NETMAP --to 10.5.5.0/24
sysctl -w net.ipv4.conf.wlan1.rp_filter=2
sysctl -w net.ipv4.conf.wlan2.rp_filter=2
