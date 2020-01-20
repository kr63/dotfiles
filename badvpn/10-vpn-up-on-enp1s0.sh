#!/bin/sh

# start vpn & set mtu after $my_ethernet up
# tun0 --> vpn device

my_con="enp1s0"
my_vpn="rtlabs_vpn"

if [ "$1" = $my_con ]; then
	case "$2" in
		up)
			nmcli connection up $my_vpn
			;;
		down)
			nmcli connection down $my_vpn
			;;
	esac
fi

