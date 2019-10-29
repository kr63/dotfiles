#!/bin/sh

# place this script to the /etc/NetworkManager/dispatcher.d folder & start NetworkManager-dispatcher.service
# setup tunnel after vpn up & down

my_vpn="tun0"
my_tun="tun99"

if [ "$1" = $my_vpn ]; then
	case "$2" in
		up)
			# setup my_tun
			systemctl start tun2socks.service
			ip link set dev $my_tun down
			ip link set mtu 1300 dev $my_tun
			ip addr add dev $my_tun 10.0.1.3/24
			ip link set dev $my_tun up

			# setup routing table
			ip route add 192.168.15.0/24 dev $my_tun via 10.0.1.4
			;;
		down)
			# clean everything
			systemctl stop tun2socks.service

			# reconnect my_vpn
			nmcli connection up rtlabs_vpn
			ip link set mtu 1300 dev $my_vpn
			;;
	esac
fi


	

