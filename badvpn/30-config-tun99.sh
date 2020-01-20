#!/bin/sh

# setup $my_tun when $my_vpn up

my_tun="tun99"
my_vpn="tun0"

if [ "$1" = $my_vpn ]; then
	case "$2" in
		up)
			# setup my_tun
			ip link set mtu 1300 dev $my_tun
			ip addr add dev $my_tun 10.0.1.3/24
			ip link set dev $my_tun up

			# setup routing table
			ip route add 192.168.15.0/24 dev $my_tun via 10.0.1.4
			ip route add 192.168.2.0/24 dev $my_tun via 10.0.1.4
			;;
		down)
			# clean route table
			ip route del 192.168.15.0/24 dev $my_tun via 10.0.1.4
			ip route del 192.168.2.0/24 dev $my_tun via 10.0.1.4
			;;
	esac
fi


	

