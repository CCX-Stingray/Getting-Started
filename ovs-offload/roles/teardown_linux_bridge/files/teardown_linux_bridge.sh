#!/bin/sh

NUM_VFS=$1
LAST_VF=$(($NUM_VFS - 1))

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
  nmcli con del bridge-slave-enP8p1s5$SUFFIX
  sleep 1
  ip link set dev enP8p1s5$SUFFIX up
done

nmcli con del bridge-linux-br0
