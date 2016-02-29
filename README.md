sf-farm-inspector extension provides scripts allowing:

- reading /etc/passwd and /etc/group files from all hosts in a farm, and
  create scripts that recreate existing users/group on a clean system,
  with the same details as on original system
- analyzing disk usage on all hosts in a farm, and provide JSON files
  with usage data, that can be further analyzed by some external tool
- dumping configuration from network devices (currently from MikroTik
  and Cisco IOS based routers)
