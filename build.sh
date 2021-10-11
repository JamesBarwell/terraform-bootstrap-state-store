#!/bin/bash

terraform init -input=false

if [ $? != 0 ]; then
  echo "Could not find remote backend - boostrapping infrastructure with local state"
  cp override/override.tf .
  terraform init -input=false -reconfigure
  terraform apply -input=false -auto-approve
  rm override.tf

  echo "Reconfigure to use remote backend and copy state"
  terraform init -migrate-state -force-copy

  echo "Clean up and synchronise local state"
  rm terraform.tfstate
  terraform apply -input=false -refresh-only -auto-approve

  echo "Environment creation successful"
else
  echo "Remote backend configured - proceeding with apply"
  terraform apply -input=false -auto-approve
fi
