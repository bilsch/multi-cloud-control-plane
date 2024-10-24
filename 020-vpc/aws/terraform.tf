terraform {
  required_providers {
    aws = {
      version = "~> 5.72.1"
    }

    random = {
      version = "~> 3.6.3"
    }

    vault = {
      version = "~> 4.4.0"
    }
  }

  # TODO: This should be using the s3 / dynamodb from 005-terraform-state not consul
  backend "consul" {
    address = "consul.bilsch.org:8501"
    scheme  = "https"
    path    = "terraform/state/020-vpc/aws"
  }

  required_version = "~> 1.9.7"
}

provider "vault" {
  # Note we are taking from the shell environment for address and token
}
