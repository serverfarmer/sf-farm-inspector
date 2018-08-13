#!/bin/bash
. /opt/farm/scripts/init


path=/etc/local/.farm
servers="`cat $path/virtual.hosts $path/physical.hosts $path/workstation.hosts $path/problematic.hosts |grep -v ^#`"

for server in $servers; do

	if [[ $server =~ ^[a-z0-9.-]+$ ]]; then
		server="$server::"
	elif [[ $server =~ ^[a-z0-9.-]+[:][0-9]+$ ]]; then
		server="$server:"
	fi

	host=$(echo $server |cut -d: -f1)
	port=$(echo $server |cut -d: -f2)

	if [ "$port" = "" ]; then
		port=22
	fi

	sshkey=`/opt/farm/ext/keys/get-ssh-management-key.sh $host`

	/opt/farm/ext/farm-inspector/utils/users.php $host root@$host $port root $sshkey \
		|/opt/farm/ext/versioning/save.sh daily /var/cache/farm users-$host.script

done

/opt/farm/ext/farm-inspector/utils/users.php "" root@$HOST "" "" "" \
	|/opt/farm/ext/versioning/save.sh daily /var/cache/farm users-$HOST.script
