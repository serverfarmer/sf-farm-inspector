#!/bin/bash
. /opt/farm/scripts/init
. /opt/farm/scripts/functions.custom


create_json() {
	out=$1
	file=usage-$2.json

	if [ ! -f $out/$file ]; then
		echo "{}" >$out/$file
	fi

	echo $file
}

ignore_root() {
	inspect=$1
	host=$2

	if [ "`echo $host |grep -xFf $inspect`" != "" ]; then
		echo 0
	else
		echo 1
	fi
}



out=/var/cache/farm

path=/etc/local/.farm
servers="`cat $path/virtual.hosts $path/physical.hosts $path/workstation.hosts |grep -vxFf $path/openvz.hosts`"

expand=$path/expand.json
inspect=$path/inspect.root

for server in $servers; do

	if [ -z "${server##*:*}" ]; then
		host="${server%:*}"
		port="${server##*:}"
	else
		host=$server
		port=22
	fi

	sshkey=`ssh_management_key_storage_filename $host`
	ignore=`ignore_root $inspect $host`
	file=`create_json $out $host`

	/opt/farm/ext/farm-inspector/utils/space.php $ignore $host $port root $sshkey $out/$file $expand $@ \
		|/opt/farm/ext/farm-inspector/utils/save.sh $out $file &

done

ignore=`ignore_root $inspect $HOST`
file=`create_json $out $HOST`

/opt/farm/ext/farm-inspector/utils/space.php $ignore localhost - - - $out/$file $expand $@ \
	|/opt/farm/ext/farm-inspector/utils/save.sh $out $file
