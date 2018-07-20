#!/bin/bash
. /opt/farm/scripts/functions.custom
. /opt/farm/ext/keys/functions


# http://fajne.it/automatyzacja-backupu-routera-mikrotik.html
sshkey=`ssh_network_device_key_storage_filename mikrotik`
for router in `cat /etc/local/.farm/mikrotik.hosts |grep -v ^#`; do

	if [[ $router =~ ^[a-z0-9.-]+$ ]]; then
		router="$router::"
	elif [[ $router =~ ^[a-z0-9.-]+[:][0-9]+$ ]]; then
		router="$router:"
	fi

	host=$(echo $router |cut -d: -f1)
	port=$(echo $router |cut -d: -f2)

	if [ "$port" = "" ]; then
		port=22
	fi

	ssh -y -i $sshkey -p $port -o StrictHostKeyChecking=no admin@$host export \
		|/opt/farm/ext/farm-inspector/utils/save.sh /var/cache/farm mikrotik-$host.config

done


# https://supportforums.cisco.com/document/110946/ssh-using-public-key-authentication-ios-and-big-outputs
sshkey=`ssh_network_device_key_storage_filename cisco`
for router in `cat /etc/local/.farm/cisco.hosts |grep -v ^#`; do

	if [[ $router =~ ^[a-z0-9.-]+$ ]]; then
		router="$router::"
	elif [[ $router =~ ^[a-z0-9.-]+[:][0-9]+$ ]]; then
		router="$router:"
	fi

	host=$(echo $router |cut -d: -f1)
	port=$(echo $router |cut -d: -f2)

	if [ "$port" = "" ]; then
		port=22
	fi

	ssh -y -i $sshkey -p $port -o StrictHostKeyChecking=no admin@$host "show running-config" \
		|/opt/farm/ext/farm-inspector/utils/save.sh /var/cache/farm cisco-$host.config

	ssh -y -i $sshkey -p $port -o StrictHostKeyChecking=no admin@$host "show tech-support" \
		|/opt/farm/ext/farm-inspector/utils/save.sh /var/cache/farm cisco-$host.tech

done
