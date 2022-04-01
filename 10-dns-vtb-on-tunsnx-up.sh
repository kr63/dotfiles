#!/bin/sh

# setup dns for specific connection after $my_con up

my_con="tunsnx"
dns1=10.230.192.78
dns2=10.230.192.77
dns3=10.64.32.245
dns4=10.64.32.246

interface=$1 status=$2
if [ "$interface" = $my_con ]; then
    case "$status" in
        up)
            systemd-resolve --interface=$my_con --set-dns=$dns1 --set-dns=$dns2 --set-dns=$dns3 --set-dns=$dns4 --set-domain=corp.dev.vtb --set-domain=vtb.ru --set-domain=vtb24.ru --set-domain=vtb.grp --set-domain=vtb.com --set-domain=region.vtb.ru
            sleep 3
            for r in $(ip route | awk 'match($3, /tunsnx/) {print $1}' | grep -v -E '^10.'); do ip route del $r;done
            ip route add 10.0.0.0/8 dev tunsnx
            ;;
    esac
fi

