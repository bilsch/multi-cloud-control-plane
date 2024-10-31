locals {
  # TODO this path sucks!
  config = yamldecode(file("/Users/bilsch/gits/multi-cloud-control-configs-private/clouds/azure/${var.profile}.yaml"))
}

module "vpc" {
  source = "git@github.com:bilsch/terraform-azure-vpc.git"

  tags = {
    profile = var.profile,
  }
}
