#/bin/bash

#deployment ID
deployment_id="*"

#List VM Before Prune
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