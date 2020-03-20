#! /bin/sh

HOST_PF=$1
NUM_VFS=$2
LAST_VF=$(($NUM_VFS - 1))

# Create VFs
# Will always pair with PF4 on the ARM side
ip link set dev enP8p1s0f4 up
echo $NUM_VFS > /sys/class/net/enP8p1s0f4/device/sriov_numvfs

# Bring up VF interfaces
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

# Create VF pairs
for i in $(seq 0 $LAST_VF)
do
  bnxt-ctl add-vf2fn enP8p1s0f4 mm$i vf $i host 1 pf $HOST_PF vf $i
done
