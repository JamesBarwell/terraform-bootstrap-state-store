terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }

  backend "http" {
    address        = "http://127.0.0.1:8000/state"
    lock_address   = "http://127.0.0.1:8000/state"
    unlock_address = "http://127.0.0.1:8000/state"
    username       = "terraform"
    password       = "terraform"
  }
}

provider "docker" {}

module "state" {
  source = "./modules/state"
}

module "webserver1" {
  source = "./modules/webserver"
  container_name = "nginx-container-1"
  external_port = 8080
}

#module "webserver2" {
#  source = "./modules/webserver"
#  container_name = "nginx-container-2"
#  external_port = 8081
#}
