#!/bin/bash

entries=(
  "192.168.1.72   hypervisor   	hyper.local"
  "192.168.1.111  vm1 vm1.local node1"
  "192.168.1.112  vm2 vm2.local node2"
)

for entry in "${entries[@]}"; do
  echo "$entry" >> /etc/hosts
done

