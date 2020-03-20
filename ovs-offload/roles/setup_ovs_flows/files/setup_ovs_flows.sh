#!/bin/sh

 ovs-ofctl add-flow ovs-br0 dl_dst=52:60:1b:f2:d2:d6,actions=output:1
 ovs-ofctl add-flow ovs-br0 dl_dst=F2:12:6D:67:8D:10,actions=output:2
 ovs-ofctl add-flow ovs-br0 dl_dst=82:59:F3:2E:BE:2A,actions=output:3
 ovs-ofctl add-flow ovs-br0 dl_dst=f6:5f:c1:d6:11:85,actions=output:4
 ovs-ofctl add-flow ovs-br0 dl_dst=7a:1e:94:0c:ff:d1,actions=output:5
 ovs-ofctl add-flow ovs-br0 dl_dst=62:52:51:9e:4d:0b,actions=output:6
 ovs-ofctl add-flow ovs-br0 dl_dst=86:95:ef:1b:93:f6,actions=output:7
 ovs-ofctl add-flow ovs-br0 dl_dst=16:74:b2:4e:92:40,actions=output:8
