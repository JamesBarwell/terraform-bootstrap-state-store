#!/bin/bash

terraform init -input=false

if [ $? != 0 ]; then
  echo "Could not find remote backend - boostrapping infrastructure with local backend"

  cp override/override.tf .
  terraform init -input=false -reconfigure

  terraform apply -input=false -auto-approve
  if [ $? != 0 ]; then
    echo "Terraform error when applying initial environment"
    exit 1
  fi

  rm override.tf

  echo "Reconfigure to use remote backend and migrate state"
  terraform init -migrate-state -force-copy
  if [ $? != 0 ]; then
    echo "Terraform error when reconfiguring to use remote backend"
    exit 1
  fi

  echo "Clean up and synchronise local state"
  rm terraform.tfstate
  terraform apply -input=false -refresh-only -auto-approve
  if [ $? != 0 ]; then
    echo "Terraform error when refreshing state"
    exit 1
  fi

  echo "Environment creation successful"
else
  echo "Remote backend configured - proceeding with apply"
  terraform apply -input=false -auto-approve

  if [ $? != 0 ]; then
    echo "Terraform error when applying environment update"
    exit 1
  fi
fi
