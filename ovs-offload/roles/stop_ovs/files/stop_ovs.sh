#!/bin/sh

NUM_VFS=$1
LAST_VF=$(($NUM_VFS - 1))

# Stop OVS
kill `cd /var/run/openvswitch && cat ovsdb-server.pid ovs-vswitchd.pid`

# Unbind VF interfaces from DPDK
for i in $(seq 0 $LAST_VF)
do
  /usr/share/dpdk/usertools/dpdk-devbind.py -u 0008:01:05.$i
  /usr/share/dpdk/usertools/dpdk-devbind.py --bind=bnxt_en 0008:01:05.$i
done
rmmod igb_uio
sleep 5
for i in $(seq 0 $LAST_VF)
do
  if [ $i -eq 0 ]
  then
    SUFFIX=""
  else
    SUFFIX=f$i
  fi
  ip link set dev enP8p1s5$SUFFIX up
done
