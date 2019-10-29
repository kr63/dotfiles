#!/bin/sh

# place this script to the /etc/NetworkManager/dispatcher.d folder & start NetworkManager-dispatcher.service
# start vpn & set mtu after $my_ethernet up
# tun0 --> vpn device

my_ethernet="enp1s0"
my_vpn="rtlabs_vpn"

if [ "$1" = $my_ethernet ]; then
	case "$2" in
		up)
			nmcli connection up $my_vpn
			ip link set mtu 1300 dev tun0
			;;
		down)
			;;
	esac
fi

