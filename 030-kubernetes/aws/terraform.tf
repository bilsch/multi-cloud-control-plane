terraform {
  required_providers {
    aws = {
      version = "~> 5.74"
    }

    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.0"
    }

    vault = {
      version = "~> 4.4.0"
    }
  }

  # TODO: This should be using the s3 / dynamodb from 005-terraform-state not consul
  backend "consul" {
    path = "terraform/state/030-kubernetes/aws/lab"
  }

  required_version = "~> 1.9.7"
}

provider "vault" {
  # Note we are taking from the shell environment for address and token
}
