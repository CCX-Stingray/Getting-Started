### Introduction
It is possible to install a stock CentOS Linux distribution on the SmartNIC. Once that is done, a common use-case would be to run an OVS-DPDK or  Linux bridge and use VF-pairs to connect VMs to the bridge. This would offload the bridging function from the host to the SmartNIC. 

This document describes the software and scripts to do this in an easy and repeatable manner.

### Software
The following pieces of software have to be installed on the SmartNIC
* `bnxt-ctl`
* `DPDK`
* `OVS`

Scripts and Ansible playbooks have been developed to automate the installation of the software. They also automate the process of configuring the OVS and Linux bridges. They are executed from a machine (Config Controller) that has ssh access to the SmartNIC.

### Configuration
The Stingray device can be configured with different combinations of ARM-side and host-side PFs. For a given combination, there is flexibility in how the PFs and VFs on each side are interconnected. The diagram below shows the specific configuration and interconnection that is assumed by the scripts. They can be easily modified to work for a different configuration.

![Configuration diagram](config.png)

This configuration allows 8 VMs on the host to use 8 VFs which are connected to the bridge running on the SmartNIC. This allows the VMs to communicate with each other via the bridge, just as they would if it was running on the Host instead of being offloaded to the SmartNIC.

Note that in this configuration the Host sees 4 PFs and they are numbered from 8 to 11. The ARM sees 8 PFs and they are numbered from 0 to 7.

The IP addresses shown here are just examples. The only requirement is that the machine executing the scripts (we are calling it the "Config Controller"), has `ssh` connectivity to the SmartNIC.

### Prerequisites
#### SmartNIC
1. The SmartNIC should be running CentOS 7. Instructions on installing CentOS can be found in the [Stingray PS225 Quickstart Guide](https://github.com/CCX-Stingray/Documentation/blob/master/5880X-PS225-UG1xx.pdf), section 5.2. 
2. The configuration on the card should support SR-IOV and VF pairs e.g. `bcm958802a8028_2x25g_8+4_pf.cfg`
#### Config Controller
1. Install [Ansible](https://www.ansible.com/) if the system does not have it. You can find installation instructions [here.](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html?extIdCarryOver=true&sc_cid=701f2000001OH7YAAW)
2. Add the following to your Ansible configuration  
```INI
[defaults]
gathering = smart
fact_caching = jsonfile
fact_caching_connection = <fully qualified path to a local directory>
fact_caching_timeout = 86400
```

- The Ansible configuration file can be stored in several places as described [here](https://docs.ansible.com/ansible/latest/reference_appendices/config.html). The simplest option is to create a local `ansible.cfg` file in the `ovs-offload` directory.  
- The path to the cache directory must be a *"a local filesystem path to a writeable directory (Ansible will attempt to create the directory if one does not exist)"* as explained [here](https://docs.ansible.com/ansible/2.5/user_guide/playbooks_variables.html#fact-caching) 
3. Ensure [ssh access](https://docs.ansible.com/ansible/latest/user_guide/connection_details.html#ssh-key-setup) to the SmartNIC. The public key of the Config Controller should be registered as an authorized key on the SmartNIC.
### Installation and Usage
1. Clone this repository; then `cd ovs-offload`
2. To install all the necessary software on the SmartNIC, run
	`install.sh`
3. To configure a Linux bridge and connect the VF pairs as shown in the diagram, run `linux_bridge.sh`
4. To configure an OVS bridge and connect the VF pairs as shown in the diagram,
  - Edit the file `roles/setup_ovs_flows/files/setup_ovs_flows.sh` to configure OpenFlow rules that match the MAC addresses of the VFs on your Host. If these rules will be configured elsewhere (say by an OpenFlow controller), comment out all the lines in this file.
  - Run `ovs_bridge.sh`
5. The IP address of the SmartNIC, the Host PF and other parameters can be configured in the `inventory` file.  
For example:  
`smartnic ansible_host=10.0.0.12 host_pf=8 num_vfs=8 bridge_ip=10.0.0.10 gateway_ip=10.0.0.1`  
Note: The variable ansible_host refers to the SmartNIC itself, not the Host machine in which it is installed (labeled as Host in the diagram).
6. To configure multiple hosts, additional lines can be added to the `inventory` file, one per host.  
7. By default, the bridge is not connected to the external network. To connect it, run `connect_bridge_external.sh` and to disconnect run `disconnect_bridge_external.sh`.
8. To undo all the configuration and remove the bridge (Linux or OVS), run `teardown_all.sh`
9. The scripts keep track of what is configured and started. This allows you to run the scripts multiple times without error; they simply skip what has already been configured. Running the `teardown_all.sh` script updates the history. However, if you have a bridge running and reboot the SmartNIC without executing the `teardown_all.sh` script, the actual state of the card will no longer be in sync with the history maintained by the scripts. In that case, run the `flush_history.sh` script to flush the history.
### Performance
`iperf` can be used to test the throughput across the bridge - between two VFs and from a VF to the external network. On our test setup, this is what we measured.
#### VF to VF
```
ip netns exec ns6 iperf3 -P 24 -l 256K -w 512K -c 10.0.0.25  
[SUM]   0.00-10.00  sec  26.2 GBytes  22.5 Gbits/sec  367401 sender  
[SUM]   0.00-10.00  sec  26.2 GBytes  22.5 Gbits/sec         receiver    
```
### VF to Network
```
ip netns exec ns6 iperf3 -P 24 -l 256K -w 512K -c 10.0.0.1  
[SUM]   0.00-10.00  sec  26.2 GBytes  22.5 Gbits/sec  1013   sender  
[SUM]   0.00-10.00  sec  26.2 GBytes  22.5 Gbits/sec         receiver    
```
