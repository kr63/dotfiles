#!/bin/sh

my_tun=tun99
proxy=10.68.8.103:1080

ip link set mtu 1300 dev tun0

# setup tunnel
ip tuntap del dev $my_tun mode tun
ip tuntap add dev $my_tun mode tun user root
ip link set dev $my_tun down
ip link set mtu 1300 dev $my_tun
ip addr add dev $my_tun 10.0.0.1/24
ip link set dev $my_tun up

# setup routing table
ip route add 192.168.15.0/24 dev $my_tun via 10.0.0.2

#badvpn-tun2socks --loglevel info --tundev $my_tun --netif-ipaddr 10.0.0.2 --netif-netmask 255.255.255.0 --socks-server-addr $proxy
badvpn-tun2socks --loglevel none --tundev $my_tun --netif-ipaddr 10.0.0.2 --netif-netmask 255.255.255.0 --socks-server-addr $proxy &

