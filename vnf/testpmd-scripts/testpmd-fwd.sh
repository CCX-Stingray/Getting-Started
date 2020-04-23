#! /bin/sh

echo 128 > /proc/sys/vm/nr_hugepages

modprobe  vfio enable_unsafe_noiommu_mode=1
modprobe vfio-pci

echo 0 > /sys/bus/pci/devices/0000\:00\:01.0/numa_node
echo 0 > /sys/bus/pci/devices/0000\:00\:02.0/numa_node

echo "14e4 d800" > /sys/bus/pci/drivers/vfio-pci/new_id
echo 0000:00:01.0 > /sys/bus/pci/devices/0000\:00\:01.0/driver/unbind
echo 0000:00:01.0 > /sys/bus/pci/drivers/vfio-pci/bind
echo 0000:00:02.0 > /sys/bus/pci/devices/0000\:00\:02.0/driver/unbind
echo 0000:00:02.0 > /sys/bus/pci/drivers/vfio-pci/bind

# port 0 is connected to the packet generator, port 1 is connected to PF10 on the host which is the packet receiver; edit the MAC addresses to match those on your system
testpmd -c 0x3 -n 1 -- -i --total-num-mbufs=16384 --eth-peer=0,00:0a:f7:ac:80:80  --eth-peer=1,00:10:18:ad:05:0a
