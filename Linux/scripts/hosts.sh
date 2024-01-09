#!/bin/bash

entries=(
  "192.168.0.2   hypervisor   	hyper.local"
  "192.168.0.11  vm1 vm1.local node1"
  "192.168.0.12  vm2 vm2.local node2"
)

for entry in "${entries[@]}"; do
  echo "$entry" >> /etc/hosts
done

