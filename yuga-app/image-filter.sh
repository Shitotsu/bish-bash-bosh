#!/bin/bash
var=$(trivy image -q --vuln-type os --severity critical --format json lamad-harbor.lab:5000/lambda-registry/yuga-app:v5.0.0 | grep CRITICAL | sed -e 's|[",'\'']||g'|cut -d " " -f 12 | uniq )
if [[ -n $var ]];
then
  echo "THERE ARE STILL CRICITAL VULNERABLE!"
  echo "IMAGE WILL NOT BE REDEPLOYED"
  exit 1
else
  echo "IMAGE PASSED VULNERABLE ASSESSMENT!"
  echo "IMAGE WILL DEPLOYED SOON.."
  kubectl apply -f rsvp.yaml
  kubectl rollout restart deployment rsvp
fi
