#!/bin/sh

/usr/share/dpdk/usertools/dpdk-devbind.py -u 0008:01:00.0
/usr/share/dpdk/usertools/dpdk-devbind.py --bind=bnxt_en 0008:01:00.0
ip link set dev enP8p1s0f0 down
sleep 10
ip addr add 192.168.1.10/24 dev enP8p1s0f0
ip link set dev enP8p1s0f0  up
