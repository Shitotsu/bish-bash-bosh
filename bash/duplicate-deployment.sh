#!/bin/bash

NAMESPACE="default"
OUTPUT_DIR="deployment_yaml"
LIST_FILE="deployment_list.txt"
TEMPLATE_YAML="nesting.yaml"

# buat direktori
mkdir -p $OUTPUT_DIR

# Ngambil daftar deployment
deployments=$(kubectl get deployments -n $NAMESPACE -o jsonpath='{.items[*].metadata.name}')

# Simpan deployment kedalam yaml file
for deployment in $deployments; do
    filename="$deployment.yaml"
    list="$deployment"
    cat $TEMPLATE_YAML | sed 's|testing|'$deployment'-prod|g' > $filename
    mv $filename $OUTPUT_DIR
    echo "$list" >> $OUTPUT_DIR/$LIST_FILE
    echo "Deployment '$deployment' berhasil disalin ke '$filename'"
done

echo "Deployment nya disini coy!  '$OUTPUT_DIR/$LIST_FILE'"