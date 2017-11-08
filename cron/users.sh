#!/bin/bash
. /opt/farm/scripts/init
. /opt/farm/scripts/functions.custom
. /opt/farm/scripts/functions.keys


path=/etc/local/.farm
servers="`cat $path/virtual.hosts $path/physical.hosts $path/workstation.hosts $path/problematic.hosts |grep -v ^#`"

for server in $servers; do

	if [ -z "${server##*:*}" ]; then
		host="${server%:*}"
		port="${server##*:}"
	else
		host=$server
		port=22
	fi

	sshkey=`ssh_management_key_storage_filename $host`

	/opt/farm/ext/farm-inspector/utils/users.php $host root@$host $port root $sshkey \
		|/opt/farm/ext/farm-inspector/utils/save.sh /var/cache/farm users-$host.script

done

/opt/farm/ext/farm-inspector/utils/users.php "" root@$HOST "" "" "" \
	|/opt/farm/ext/farm-inspector/utils/save.sh /var/cache/farm users-$HOST.script
