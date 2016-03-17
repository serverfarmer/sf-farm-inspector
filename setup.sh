#!/bin/sh

echo "setting up base directories and files"
mkdir -p   /var/cache/farm
chmod 0700 /var/cache/farm

touch /etc/local/.config/inspect.root

if [ ! -f /etc/local/.config/expand.json ]; then
	echo -n "{}" >/etc/local/.config/expand.json
fi

if ! grep -q /opt/farm/ext/farm-inspector/cron/check.sh /etc/crontab; then
	echo "48 6 * * *   root /opt/farm/ext/farm-inspector/cron/users.sh" >>/etc/crontab
	echo "49 6 * * *   root /opt/farm/ext/farm-inspector/cron/network.sh" >>/etc/crontab
	echo "10 7 * * 1-6 root /opt/farm/ext/farm-inspector/cron/space.sh" >>/etc/crontab
	echo "10 7 * * 7   root /opt/farm/ext/farm-inspector/cron/space.sh --force" >>/etc/crontab
fi

/opt/farm/scripts/setup/role.sh sf-php
