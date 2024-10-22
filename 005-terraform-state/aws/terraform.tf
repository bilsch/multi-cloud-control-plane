terraform {
  required_providers {
    aws = {
      version = "~> 5.72.1"
    }

    random = {
      version = "~> 3.6.3"
    }
  }

  backend "consul" {
    address = "consul.bilsch.org:8501"
    scheme  = "https"
    path    = "terraform/state/005-terraform-state/aws"
  }

  required_version = "~> 1.9.7"
}
