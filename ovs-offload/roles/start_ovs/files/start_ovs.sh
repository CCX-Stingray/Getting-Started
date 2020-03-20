#!/bin/sh

NUM_VFS=$1
LAST_VF=$(($NUM_VFS - 1))

# DPDK init + binding VFs to igb_uio
mkdir -p /mnt/huge
mount -t hugetlbfs nodev /mnt/huge
echo 1024 > /proc/sys/vm/nr_hugepages

# insert igb_uio
modprobe uio
IGB_UIO_PATH=$(find /lib/modules -name igb_uio.ko)
if [ -z $IGB_UIO_PATH ]; then
  exit 1
fi
insmod $IGB_UIO_PATH

# bind interfaces to igb_uio
for i in $(seq 0 $LAST_VF)
do
  if [ $i -eq 0 ]
  then
    SUFFIX=""
  else
    SUFFIX=f$i
  fi
  ip link set dev enP8p1s5$SUFFIX down
  /usr/share/dpdk/usertools/dpdk-devbind.py -u 0008:01:05.$i
  /usr/share/dpdk/usertools/dpdk-devbind.py --bind=igb_uio 0008:01:05.$i
done

# Create if doesn't exist
if [ ! -d "/var/run/openvswitch" ]
then
        mkdir /var/run/openvswitch
fi

# Start OVS with DPDK
ovsdb-server /etc/openvswitch/conf.db -vconsole:emer -vsyslog:err -vfile:info \
--remote=punix:/var/run/openvswitch/db.sock --private-key=db:Open_vSwitch,SSL,private_key \
--certificate=db:Open_vSwitch,SSL,certificate --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
--no-chdir --log-file=/var/log/openvswitch/ovsdb-server.log --pidfile=/var/run/openvswitch/ovsdb-server.pid \
--detach --monitor
export DB_SOCK=/var/run/openvswitch/db.sock
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true
ovs-vswitchd unix:$DB_SOCK --pidfile --detach
ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=0xc0
