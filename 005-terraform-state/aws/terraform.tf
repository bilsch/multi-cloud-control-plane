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

  backend "consul" {
    address = "consul.bilsch.org:8501"
    scheme  = "https"
    # TODO how do we make this dynamic? terragrunt time finally?
    path = "terraform/state/005-terraform-state/aws/lab"
  }

  required_version = "~> 1.9.7"
}

provider "vault" {
  # Note we are taking from the shell environment for address and token
}
