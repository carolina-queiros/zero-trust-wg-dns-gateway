# Zero-Trust WireGuard Gateway & Split-Horizon DNS

Configuration files and routing scripts for my homelab remote access gateway. Built to access internal development VMs and Proxmox management interfaces from external networks without opening incoming router ports.

## Overview

- **Mesh Coordination:** Self-hosted `Headscale` instance coordinating WireGuard peers inside the `100.64.0.0/10` CGNAT address space.
- **Access Control:** Tag-based ACL policies (`config/headscale/acl.hujson`) restricting database (`1521`, `5432`) and hypervisor (`8006`) ports to authenticated identities.
- **Private DNS & Split Tunneling:** `AdGuard Home` bound strictly to the WireGuard interface (`100.64.0.1:53`). Resolves internal `*.lab.internal` records locally and forwards external queries over DoH.
- **Host Firewalling:** `scripts/wg-gateway-up.sh` handles IPv4 forwarding, MTU clamping (`1280`), and drops external port 53 traffic on `eth0`.

## Layout

- `docker-compose.yml` — Container definitions for Headscale and AdGuard Home.
- `config/headscale/config.yaml` — Control plane settings, SQLite backend, and MagicDNS configuration.
- `config/headscale/acl.hujson` — Node identity groups and port-level firewall rules.
- `config/adguard/AdGuardHome.yaml` — Upstream DoH resolvers and local `*.lab.internal` A-record rewrites.
- `scripts/wg-gateway-up.sh` — Interface initialization, NAT masquerading, and iptables rules.
