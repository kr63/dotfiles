#!/bin/sh

my_dev=enp1s0
new_address=00:21:91:f8:ea:ac

ip link set dev $my_dev down
ip link set dev $my_dev address $new_address
ip link set dev $my_dev up
