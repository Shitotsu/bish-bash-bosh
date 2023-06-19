#!/bin/bash

OUTPUT_DIR="deployment_yaml"
LIST_FILE="deployment_list.txt"

# Read deployment
deployment_files=$(cat $OUTPUT_DIR/$LIST_FILE)

# Apply yang ada di list
for file in $deployment_files; do
    kubectl apply -f $file
    echo "File '$file' berhasil diapply"
done
