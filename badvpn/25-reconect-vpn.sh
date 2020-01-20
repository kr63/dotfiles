#!/bin/sh

# start vpn & set mtu after $my_ethernet up
# tun0 --> vpn device

my_tun="tun0"
my_vpn="rtlabs_vpn"

# $1 --> interface name
# $2 --> action

if [ "$1" = $my_tun ]; then
	case "$2" in
		up)
			ip link set mtu 1300 dev $my_tun
			;;
		down)
			nmcli connection up $my_vpn
			ip link set mtu 1300 dev $my_tun
			;;
		vpn-down)
			nmcli connection up $my_vpn
			ip link set mtu 1300 dev $my_tun
			;;
	esac
fi

