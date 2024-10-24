locals {
  # TODO this path sucks!
  config = yamldecode(file("/Users/bilsch/gits/multi-cloud-control-configs-private/clouds/aws/${var.profile}.yaml"))
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.profile
  cidr = config.vpc.cidr

  azs              = config.provider.azs
  private_subnets  = config.vpc.private_subnets
  database_subnets = config.vpc.database_subnets
  public_subnets   = config.vpc.public_subnets
  intra_subnets    = config.vpc.kubernetes_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  tags = {
    Terraform   = "true"
    Environment = var.profile
  }
}