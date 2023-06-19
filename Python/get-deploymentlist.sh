#/bin/bash
kubectl get deployments -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' > deployment_list.txt