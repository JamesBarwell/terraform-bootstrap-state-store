terraform-bootstrap-state-store
---

This repository is an example of how to solve the Terraform state chicken and egg problem, where we want to store Terraform state in a store that is itself managed by Terraform.

The demo uses Docker as its provider to avoid any external dependencies. The same pattern should work with other providers such as AWS and Azure.

## How to use

Run the make command to set up your infrastructure. The command will bootstrap the state store if required, i.e. when run for the first time.
```
make
```

The infrastructure will now match the definition of `main.tf`, which in this example gives you a state store and a webserver.

You can then modify the `main.tf` file and continue to run the `make` command to apply futher changes. An example second webserver is available in the file, with its definition commented out. To complete the demo, uncomment this definition and run `make` again. Then confirm with `docker ps` that you now have two webservers running.


When done, run the clean command to remove your infrastructure.
```
make clean
```

## How does it work?

The `main.tf` file is set up to use a remote backend that doesn't yet exist. When first running `terraform init`, this causes an error which is caught and used to run a separate bootstrapping process.

During bootstrapping, an override is created which instructs Terraform to use the local backend. Then `terraform init` is run again, to configure this local backend, and `terraform apply` is run to create the full infrastructure. The `terraform.tfstate` is output locally.

Finally, the override is removed and `terraform init` is run once more to reconfigure to the remote storage that was just set up. This also migrates the state file from local disk to the remote store. The local file it then removed, and the backend state is re-synchronised.

If the infrastructure already exists, the initial `terraform init` will not error, so the bootstrap process is not run and the script proceeds directly to run `terraform apply`.
