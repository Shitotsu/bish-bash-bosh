#!/bin/bash

deployment_id="your-deployment-id"
vm_list_file="path/to/vm-id-list.txt"
command="/var/vcap/packages/docker/bin/docker -H unix:///var/vcap/sys/run/docker/docker.sock image prune -f"

# Loop 
while IFS= read -r vm_id
do
    # Eksekusi perintah bosh ssh
    bosh -d "$deployment_id" ssh "$vm_id" "$command"
done < "$vm_list_file"
