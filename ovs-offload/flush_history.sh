#! /bin/sh

ansible-playbook -i inventory playbooks/set_no_bridge_connected_external.yml
ansible-playbook -i inventory playbooks/set_no_ovs_bridge.yml
ansible-playbook -i inventory playbooks/set_no_ovs.yml
ansible-playbook -i inventory playbooks/set_no_pairs.yml
ansible-playbook -i inventory playbooks/set_no_linux_bridge.yml


