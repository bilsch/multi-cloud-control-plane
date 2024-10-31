terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.6.0"
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
    path = "terraform/state/030-kubernetes/azure/lab"
  }

}

provider "azurerm" {
  features {}
}

provider "vault" {
  # Note we are taking from the shell environment for address and token
}
