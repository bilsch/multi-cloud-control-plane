locals {
  # TODO this path sucks!
  config = yamldecode(file("/Users/bilsch/gits/multi-cloud-control-configs-private/clouds/azure/${var.profile}.yaml"))
}

module "vpc" {
  source = "github.com/bilsch/terraform-azure-vpc"

  name = var.profile

  cidr = local.config.vpc.cidr

  dns_servers = local.config.vpc.dns_servers

  public_subnets     = local.config.vpc.public_subnets
  private_subnets    = local.config.vpc.private_subnets
  database_subnets   = local.config.vpc.database_subnets
  kubernetes_subnets = local.config.vpc.kubernetes_subnets

  tags = {
    profile = var.profile,
  }
}
