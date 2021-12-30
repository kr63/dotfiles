#!/bin/sh

# setup dns for specific connection after $my_con up

my_con="tunsnx"
interface=$1 status=$2
if [ "$interface" = $my_con ]; then
	case "$status" in
		up)
			systemd-resolve --interface=$my_con --set-dns=10.64.32.245 --set-dns=10.64.32.246 --set-domain=vtb.ru --set-domain=vtb --set-domain=region.vtb.ru --set-domain=vtb24.ru
			;;
	esac
fi

