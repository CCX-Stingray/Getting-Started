#!/bin/sh

NUM_VFS=$1
LAST_VF=$(($NUM_VFS - 1))
BRIDGE_IP=$2
GATEWAY_IP=$3

# Create VFs
nmcli con add type bridge ifname linux-br0 ipv4.addresses $BRIDGE_IP/24 ipv4.gateway $GATEWAY_IP ipv4.dns 8.8.8.8 ipv4.method manual autoconnect yes ipv6.method ignore
sleep 1

for i in $(seq 0 $LAST_VF)
do
  if [ $i -eq 0 ]
  then
    SUFFIX=""
  else
    SUFFIX=f$i
  fi
  ip link set dev enP8p1s5$SUFFIX down
  sleep 1
  nmcli con add type ethernet ifname enP8p1s5$SUFFIX master bridge-linux-br0
  sleep 1
  ip link set dev enP8p1s5$SUFFIX up
done
