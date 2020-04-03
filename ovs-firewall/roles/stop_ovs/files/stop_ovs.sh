#!/bin/sh

# Stop OVS
kill `cd /var/run/openvswitch && cat ovsdb-server.pid ovs-vswitchd.pid`

PFS=(0 1 4 5)
for i in ${PFS[*]}
do
  /usr/share/dpdk/usertools/dpdk-devbind.py -u 0008:01:00.$i
  /usr/share/dpdk/usertools/dpdk-devbind.py --bind=bnxt_en 0008:01:00.$i
done
rmmod igb_uio
sleep 5
for i in ${PFS[*]}
do
  if [ $(($i % 2)) -eq 0 ]; then
    SUFFIX=$i
  else
    SUFFIX=$i"d1"
  fi
  ip link set dev enP8p1s0f$SUFFIX up
done
