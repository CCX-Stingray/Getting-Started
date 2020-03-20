#! /bin/sh

NUM_VFS=$1
LAST_VF=$(($NUM_VFS - 1))

# Delete VF pairs
for i in $(seq 0 $LAST_VF)
do
  bnxt-ctl del-pair enP8p1s0f4 mm$i
  sleep 1
done

# Delete VFs
echo 0 > /sys/class/net/enP8p1s0f4/device/sriov_numvfs

exit
