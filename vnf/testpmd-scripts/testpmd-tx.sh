#! /bin/sh

# port 0 is connected to VF0; edit the MAC address to match the MAC address of VF0 in your setup
testpmd --socket-mem=2048 -b 0000:01:00.1 --proc-type=auto  --file-prefix=c0  -c 0xf -n 1 -- -i --total-num-mbufs=8192 --eth-peer=0,3e:76:d5:ef:39:f2 --nb-cores=3 --rxq=2 --txq=2 --txonly-multi-flow
