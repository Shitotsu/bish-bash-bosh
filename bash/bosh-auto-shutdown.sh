#!/bin/bash

#BOSH Deployment ID (Ubah Sesuai Kebutuhan)
echo "Masukan target deployment ID!"
read -p "Enter Deployment ID: " deployment_id
echo "Masukan VM ID yang ingin dishutdown!"
read -p "Enter VM ID: " vm_id

read -p "Dah yaqin belum banh? [Y/N]: " confirm
if [[ "$confirm" == [yY] ]]; then
    echo "$deployment_id"

    # Perintah yang akan dieksekusi pada setiap VM
    command="shutdown -h now"

    # Eksekusi perintah
    bosh -d "$deployment_id" ssh "$vm_id" "$command"
else
    echo "Dibatalkan!"
    exit 1
fi