#! /bin/sh

echo 1 > /sys/class/net/enP8p1s0f4/device/sriov_numvfs
sleep 1
echo 1 > /sys/class/net/enP8p1s0f2/device/sriov_numvfs
sleep 1

echo '14e4 d800' > /sys/bus/pci/drivers/vfio-pci/new_id
echo 0008:01:05.0 > /sys/bus/pci/devices/0008\:01\:05.0/driver/unbind
echo 0008:01:05.0 > /sys/bus/pci/drivers/vfio-pci/bind
echo 0008:01:03.0 > /sys/bus/pci/devices/0008\:01\:03.0/driver/unbind
echo 0008:01:03.0 > /sys/bus/pci/drivers/vfio-pci/bind
