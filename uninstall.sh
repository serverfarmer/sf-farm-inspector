#!/bin/sh

if grep -q /opt/sf-farm-inspector/cron /etc/crontab; then
	sed -i -e "/\/opt\/sf-farm-inspector\/cron/d" /etc/crontab
fi
