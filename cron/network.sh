#!/bin/bash
. /opt/farm/scripts/functions.custom


# http://fajne.it/automatyzacja-backupu-routera-mikrotik.html
for router in `cat /etc/local/.farm/mikrotik.hosts |grep -v ^#`; do

	if [ -z "${router##*:*}" ]; then
		host="${router%:*}"
		port="${router##*:}"
	else
		host=$router
		port=22
	fi

	ssh -y -i /etc/local/.ssh/id_backup_mikrotik -p $port -o StrictHostKeyChecking=no admin@$host export \
		|/opt/farm/ext/farm-inspector/utils/save.sh /var/cache/farm mikrotik-$host.config

done


# https://supportforums.cisco.com/document/110946/ssh-using-public-key-authentication-ios-and-big-outputs
for router in `cat /etc/local/.farm/cisco.hosts |grep -v ^#`; do

	if [ -z "${router##*:*}" ]; then
		host="${router%:*}"
		port="${router##*:}"
	else
		host=$router
		port=22
	fi

	ssh -y -i /etc/local/.ssh/id_backup_cisco -p $port -o StrictHostKeyChecking=no admin@$host "show running-config" \
		|/opt/farm/ext/farm-inspector/utils/save.sh /var/cache/farm cisco-$host.config

	ssh -y -i /etc/local/.ssh/id_backup_cisco -p $port -o StrictHostKeyChecking=no admin@$host "show tech-support" \
		|/opt/farm/ext/farm-inspector/utils/save.sh /var/cache/farm cisco-$host.tech

done
