#!/bin/sh

/opt/farm/scripts/setup/extension.sh sf-versioning
/opt/farm/scripts/setup/extension.sh sf-php

echo "setting up base directories and files"
mkdir -p   /etc/local/.farm /var/cache/farm

chmod 0700 /etc/local/.farm

chmod 0710 /var/cache/farm
chown root:www-data /var/cache/farm

touch /etc/local/.farm/inspect.root

if [ ! -f /etc/local/.farm/expand.json ]; then
	echo -n "{}" >/etc/local/.farm/expand.json
fi

if ! grep -q /opt/farm/ext/farm-inspector/cron /etc/crontab; then
	echo "48 6 * * *   root /opt/farm/ext/farm-inspector/cron/users.sh" >>/etc/crontab
	echo "10 7 * * 1-6 root /opt/farm/ext/farm-inspector/cron/space.sh" >>/etc/crontab
	echo "10 7 * * 7   root /opt/farm/ext/farm-inspector/cron/space.sh --force" >>/etc/crontab
fi

# transitional code
if grep -q /opt/farm/ext/farm-inspector/cron/network.sh /etc/crontab; then
	sed -i -e "/\/opt\/farm\/ext\/farm-inspector\/cron\/network.sh/d" /etc/crontab
fi
