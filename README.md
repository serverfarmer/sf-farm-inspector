## Deprecated

This repository contains old, deprecated extension to Server Farmer.

It was replaced with the following extensions:

- [`sm-inspect-usage`](https://github.com/serverfarmer/sm-inspect-usage) - for collecting drive usage data from all hosts in a farm, and providing JSON files, that can be further analyzed by external tools
- [`sm-inspect-users`](https://github.com/serverfarmer/sm-inspect-users) - for analyzing users/groups on each host, and creating scripts that recreate existing groups/users/passwords/keys on a clean system
- [`sm-inspect-pending`](https://github.com/serverfarmer/sm-inspect-pending) - for pulling the lists of pending system package updates from all servers in the farm (in combination with [`sf-secure-lynis`](https://github.com/serverfarmer/sf-secure-lynis) extension, cheap alternative to Lynis Enterprise)
- [`sm-inspect-routers`](https://github.com/serverfarmer/sm-inspect-routers) - for inspecting configuration of network devices (Cisco IOS, MikroTik RouterOS, Ubiquiti UniFi)
- [`sf-binary-ssh-client`](https://github.com/serverfarmer/sf-binary-ssh-client) - dependency extension, providing OpenSSH 6.7 client, required to connect to eg. some network devices, where OpenSSH 7+ deprecated several old encryption algorithms
