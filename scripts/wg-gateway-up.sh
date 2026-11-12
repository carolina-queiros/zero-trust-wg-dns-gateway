#!/usr/bin/env bash
set -euo pipefail

WG_IF='wg0'
WAN_IF='eth0'
VPN_SUBNET='100.64.0.0/10'
MTU_VAL=1280

echo '[*] enabling ipv4 forwarding...'
sysctl -w net.ipv4.ip_forward=1 > /dev/null
ip link set dev $WG_IF mtu $MTU_VAL 2>/dev/null || true

iptables -A INPUT -i $WAN_IF -p udp --dport 53 -j DROP
iptables -A INPUT -i $WAN_IF -p tcp --dport 53 -j DROP
iptables -A FORWARD -i $WG_IF -j ACCEPT
iptables -A FORWARD -o $WG_IF -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t nat -A POSTROUTING -s $VPN_SUBNET -o $WAN_IF -j MASQUERADE
echo '[+] gateway routing and firewall rules applied'
