#!/bin/sh

if [ -n "$(ip addr show|grep ovs-br0)" ]; then
  ip link set dev enP8p1s0f2 down
  sleep 5
  /usr/share/dpdk/usertools/dpdk-devbind.py -u 0008:01:00.2
  /usr/share/dpdk/usertools/dpdk-devbind.py --bind=igb_uio 0008:01:00.2

  ovs-vsctl add-port ovs-br0 pf2 -- set Interface pf2 type=dpdk options:dpdk-devargs=0008:01:00.2 ofport_request=9

  ovs-ofctl add-flow ovs-br0 dl_dst=00:0a:f7:ac:80:80,actions=output:9
elif [ -n "$(ip addr show|grep linux-br0)" ]; then
  ip link set dev enP8p1s0f2 down
  sleep 5
  nmcli con add type ethernet ifname enP8p1s0f2 master bridge-linux-br0
  sleep 5
  ip link set dev enP8p1s0f2 up
fi




