locals {
  # TODO this path sucks!
  config = yamldecode(file("../../configs/azure/${var.profile}.yaml"))
}

module "vpc" {
  source = "git@github.com:bilsch/terraform-azure-vpc.git"

  tags = {
    profile = var.profile,
  }
}
