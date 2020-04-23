#! /bin/sh

# port 0 is connected to VF1 in the VM; edit the MAC address to match the MAC address of VF1 in your setup

testpmd -c 0xf -n 1 -- -i --total-num-mbufs=8192 --nb-cores=3 --rxq=2 --txq=2 --eth-peer=0,ce:0b:c0:70:d7:ad
