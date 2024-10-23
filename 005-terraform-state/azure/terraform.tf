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
  backend "consul" {
    address = "consul.bilsch.org:8501"
    scheme  = "https"
    path    = "terraform/state/005-terraform-state/azure"
  }
}

provider "azurerm" {
  features {}
}

provider "vault" {
  # Note we are taking from the shell environment for address and token
}
