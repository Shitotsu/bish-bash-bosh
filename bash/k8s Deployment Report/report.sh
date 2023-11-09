#!/bin/bash

# Set the namespace where your deployments are located
NAMESPACE=$1

# Replace these variables with your Harbor registry information
HARBOR_URL="https://xxxx.xxxx"
HARBOR_USER="xxxx"
HARBOR_PASSWORD="xxxx"

# Get the list of deployments in the specified namespace
DEPLOYMENTS=$(kubectl get deployments -n $NAMESPACE -o custom-columns=NAME:.metadata.name --no-headers)

# Iterate through the deployments and retrieve image and size information
for DEPLOYMENT in $DEPLOYMENTS; do
  # Get the image associated with the deployment
  IMAGE=$(kubectl get deployment $DEPLOYMENT -n $NAMESPACE -o=jsonpath='{.spec.template.spec.containers[0].image}')

  # Pull image target
  docker pull $IMAGE

  # Get the size of the image (Note: This retrieves the image size from Docker Hub)
  IMAGE_SIZE=$(docker image ls $IMAGE | grep MB |awk '{print $7}')

  # Get the number of artifacts in the Harbor repository
  HARBOR_PROJECT=$(echo $IMAGE | cut -d'/' -f2 | cut -d':' -f1)
  REPO_NAME=$(echo $IMAGE | cut -d'/' -f3 | cut -d':' -f1)
  NUM_ARTIFACTS=$(curl -s -k -X GET -u $HARBOR_USER:$HARBOR_PASSWORD "$HARBOR_URL/api/v2.0/projects/$HARBOR_PROJECT/repositories/$REPO_NAME/artifacts" |  jq |grep artifact_id | tr -d ' ' | wc -l)

  # Fix hpa name
  HPA_NAME=$(echo hpa-$DEPLOYMENT | sed 's/-prod//g')

  # Check HPA
  HPA=$(kubectl get hpa $HPA_NAME -n $NAMESPACE --ignore-not-found -o=jsonpath='{.spec.maxReplicas}')

  # Get CPU limit and memory limit information
  CPU_LIMIT=$(kubectl get deployment $DEPLOYMENT -n $NAMESPACE -o=jsonpath='{.spec.template.spec.containers[0].resources.limits.cpu}')
  MEMORY_LIMIT=$(kubectl get deployment $DEPLOYMENT -n $NAMESPACE -o=jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}')

  # Print deployment name, image, image size, and number of artifacts
  echo "Deployment: $DEPLOYMENT"
  echo "Image: $IMAGE"
  echo "Image Size: $IMAGE_SIZE MB"
  echo "Number of Artifacts: $NUM_ARTIFACTS"
  echo "HPA Max Replicas: $HPA"
  echo "CPU Limit: $CPU_LIMIT"
  echo "Memory Limit: $MEMORY_LIMIT"
  echo "================================="
  echo
done
