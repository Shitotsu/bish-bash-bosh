#!/bin/bash

#BOSH Deployment ID (Ubah Sesuai Kebutuhan)
read -p "Enter Deployment ID: " deployment_id

read -p "Deployment ID nya udah bener belom banh? [Y/N]: " confirm
if [[ "$confirm" == [yY] ]]; then
    echo "$deployment_id"

    #Listing Worker Node
    bosh vms -d $deployment_id | grep worker | awk '{print $1}' > vm-dev-list.txt

    # File yang berisi daftar vm-id
    vm_list_file="vm-dev-list.txt"

    # Perintah yang akan dieksekusi pada setiap VM
    command="/var/vcap/packages/docker/bin/docker -H unix:///var/vcap/sys/run/docker/docker.sock image prune -f"

    # Loop melalui setiap vm-id dalam file
    while IFS= read -r vm_id
    do
        # Eksekusi perintah bosh ssh
        bosh -d "$deployment_id" ssh "$vm_id" "$command"
    done < "$vm_list_file"
else
    echo "Dibatalkan!"
    exit 1
fi