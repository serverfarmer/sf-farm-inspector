#!/bin/bash
. /opt/farm/scripts/functions.custom


# http://fajne.it/automatyzacja-backupu-routera-mikrotik.html
for router in `cat /etc/local/.config/mikrotik.hosts`; do

	if [ -z "${router##*:*}" ]; then
		host="${router%:*}"
		port="${router##*:}"
	else
		host=$router
		port=22
	fi

	ssh -y -i /etc/local/.ssh/id_backup_mikrotik -p $port -o StrictHostKeyChecking=no admin@$host export \
		|/opt/sf-farm-inspector/utils/save.sh /var/cache/farm mikrotik-$host.config

done


# https://supportforums.cisco.com/document/110946/ssh-using-public-key-authentication-ios-and-big-outputs
for router in `cat /etc/local/.config/cisco.hosts`; do

	if [ -z "${router##*:*}" ]; then
		host="${router%:*}"
		port="${router##*:}"
	else
		host=$router
		port=22
	fi

	ssh -y -i /etc/local/.ssh/id_backup_cisco -p $port -o StrictHostKeyChecking=no admin@$host "show running-config" \
		|/opt/sf-farm-inspector/utils/save.sh /var/cache/farm cisco-$host.config

	ssh -y -i /etc/local/.ssh/id_backup_cisco -p $port -o StrictHostKeyChecking=no admin@$host "show tech-support" \
		|/opt/sf-farm-inspector/utils/save.sh /var/cache/farm cisco-$host.tech

done
