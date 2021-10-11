terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

resource "docker_image" "tfstated" {
  name         = "ivoronin/tfstated:latest"
  keep_locally = true
}

resource "docker_container" "tfstated" {
  image = docker_image.tfstated.latest
  name  = "tfstated-container"
  ports {
    internal = 8000
    external = 8000
  }
  env = [
    "TFSTATED_USERNAME=terraform",
    "TFSTATED_PASSWORD=terraform"
  ]
}

