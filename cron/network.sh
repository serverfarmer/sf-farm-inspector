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
