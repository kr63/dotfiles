#!/bin/sh

# reconnect to vpnc connection every 30s

CON="rtlabs_vpn"

while [ "true" ]
do
	STATUS=$(nmcli connection show --active | grep $CON | cut -f1 -d " ")
	if [ -z $STATUS ]; then
		echo "Disconnected, trying to reconnect..."
		(sleep 1s && nmcli connection up $CON)
	else
		echo "Already connected!"
	fi
	sleep 30
done

