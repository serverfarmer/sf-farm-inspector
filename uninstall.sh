#!/bin/sh

if grep -q /opt/farm/ext/farm-inspector/cron /etc/crontab; then
	sed -i -e "/\/opt\/farm\/ext\/farm-inspector\/cron/d" /etc/crontab
fi
