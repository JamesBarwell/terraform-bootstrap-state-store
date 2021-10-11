#!/bin/bash

echo "Reconfigure to use local state"
cp override/override.tf .
terraform init -migrate-state -force-copy

echo "Destroy infrastructure"
terraform apply -destroy -auto-approve

echo "Clean up"
rm override.tf
rm -f *.tfstate *.tfstate.backup .terraform.lock.hcl .terraform -rf

echo "Destroy complete"
