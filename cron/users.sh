#!/bin/bash
. /opt/farm/scripts/init
. /opt/farm/scripts/functions.custom


path=/etc/local/.config
servers="`cat $path/virtual.hosts $path/physical.hosts $path/workstation.hosts $path/problematic.hosts`"

for server in $servers; do

	if [ -z "${server##*:*}" ]; then
		host="${server%:*}"
		port="${server##*:}"
	else
		host=$server
		port=22
	fi

	sshkey=`ssh_management_key_storage_filename $host`

	/opt/sf-farm-inspector/utils/users.php $host $1 $port root $sshkey \
		|/opt/sf-farm-inspector/utils/save.sh /var/cache/farm users-$host.script

done

/opt/sf-farm-inspector/utils/users.php "" $1 "" "" "" \
	|/opt/sf-farm-inspector/utils/save.sh /var/cache/farm users-$HOST.script
