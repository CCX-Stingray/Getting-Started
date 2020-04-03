#! /bin/sh

# Internal network traffic must only be on 10.0.0.0/24
ovs-ofctl add-flow ovs-br0 "table=0,priority=50,in_port=int0,\
  ct_state=-trk,ip,ip_src=10.0.0.0/24,ip_dst=10.0.0.0/24,\
  actions=ct(table=1)"
ovs-ofctl add-flow ovs-br0 "table=0,priority=50,in_port=ext0,\
  ct_state=-trk,ip,ip_src=10.0.0.0/24,ip_dst=10.0.0.0/24,\
  actions=ct(table=1)"

ovs-ofctl add-flow ovs-br0 "table=0,priority=50,in_port=int1,\
  ct_state=-trk,ip,ip_src=10.1.1.0/24,actions=ct(table=2)"
ovs-ofctl add-flow ovs-br0 "table=0,priority=50,in_port=ext1,\
  ct_state=-trk,ip,actions=ct(table=2)"

ovs-ofctl add-flow ovs-br0 "table=0,priority=10,arp,actions=NORMAL"
ovs-ofctl add-flow ovs-br0 "table=0,priority=1,actions=drop"

# Table 1 - internal network
ovs-ofctl add-flow ovs-br0 "table=1,priority=50,in_port=int0,\
  ct_state=+new+trk,ip,actions=ct(commit),output:ext0"
# allow all inbound connections on internal network
ovs-ofctl add-flow ovs-br0 "table=1,priority=50,in_port=ext0,\
  ct_state=+new+trk,ip,actions=ct(commit),output:int0"
# allow established connections either way
ovs-ofctl add-flow ovs-br0 "table=1,priority=50,in_port=int0,\
  ct_state=+trk+est,ip,actions=output:ext0"
ovs-ofctl add-flow ovs-br0 "table=1,priority=50,in_port=ext0,\
  ct_state=+trk+est,ip,actions=output:int0"
# drop all else
ovs-ofctl add-flow ovs-br0 "table=1,priority=10,actions=drop"

# Table 2 - external network
# disallow outbound connections on TCP port 25
ovs-ofctl add-flow ovs-br0 "table=2,priority=50,in_port=int1,\
    ct_state=+new+trk,tcp,tcp_dst=25,actions=drop"
# allow all other outbound connections
ovs-ofctl add-flow ovs-br0 "table=2,priority=50,in_port=int1,\
  ct_state=+new+trk,ip,actions=ct(commit),output:ext1"
# allow inbound connection on TCP port 22
ovs-ofctl add-flow ovs-br0 "table=2,priority=50,in_port=ext1,\
  ct_state=+new+trk,tcp,tcp_dst=22,actions=ct(commit),output:int1"
# allow established connections either way
ovs-ofctl add-flow ovs-br0 "table=2,priority=50,in_port=int1,\
  ct_state=+trk+est,ip,actions=output:ext1"
ovs-ofctl add-flow ovs-br0 "table=2,priority=50,in_port=ext1,\
  ct_state=+trk+est,ip,actions=output:int1"
# drop all else
ovs-ofctl add-flow ovs-br0 "table=2,priority=10,actions=drop"
