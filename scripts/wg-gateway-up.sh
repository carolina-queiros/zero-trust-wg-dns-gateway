#!/usr/bin/env bash
set -e

WG_IF='wg0'
WAN_IF='eth0'
VPN_SUBNET='100.64.0.0/24'
MTU_VAL=1420

echo '[*] enabling ipv4 forwarding...'
sysctl -w net.ipv4.ip_forward=1 > /dev/null
ip link set dev $WG_IF mtu $MTU_VAL || true

iptables -A FORWARD -i $WG_IF -j ACCEPT
iptables -A FORWARD -o $WG_IF -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t nat -A POSTROUTING -s $VPN_SUBNET -o $WAN_IF -j MASQUERADE
