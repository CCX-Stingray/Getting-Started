#!/bin/sh

if [ -n "$(ip addr show|grep ovs-br0)" ]; then
  ovs-vsctl del-port ovs-br0 pf2
  sleep 5
  /usr/share/dpdk/usertools/dpdk-devbind.py -u 0008:01:00.2
  /usr/share/dpdk/usertools/dpdk-devbind.py --bind=bnxt_en 0008:01:00.2
  ip link set dev enP8p1s0f2 down
  sleep 5
  ip link set dev enP8p1s0f2  up
elif [ -n "$(ip addr show|grep linux-br0)" ]; then
  ip link set dev enP8p1s0f2 down
  sleep 5
  nmcli con del bridge-slave-enP8p1s0f2
  sleep 5
  ip link set dev enP8p1s0f2 up
fi




