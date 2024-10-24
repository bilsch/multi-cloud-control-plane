locals {
  # TODO this path sucks!
  config = yamldecode(file("/home/bilsch/gits/multi-cloud-control-configs-private/clouds/aws/${var.profile}.yaml"))
}

provider "aws" {
  region = local.config.provider.region
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.profile

  cidr = local.config.vpc.cidr
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets  = local.config.vpc.private_subnets
  database_subnets = local.config.vpc.database_subnets
  public_subnets   = local.config.vpc.public_subnets
  intra_subnets    = local.config.vpc.kubernetes_subnets

  public_subnet_names   = ["public-0", "public-1", "public-2"]
  database_subnet_names = ["database-0", "database-1", "database-2"]
  intra_subnet_names    = ["kubernetes-0", "kubernetes-1", "kubernetes-2"]

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  # ipv6 support
  enable_ipv6                                   = var.enable_ipv6
  public_subnet_assign_ipv6_address_on_creation = var.enable_ipv6
  public_subnet_ipv6_prefixes                   = [0, 1, 2]
  private_subnet_ipv6_prefixes                  = [3, 4, 5]
  database_subnet_ipv6_prefixes                 = [6, 7, 8]
  intra_subnet_ipv6_prefixes                    = [9, 10, 11]

  # We want all security defaults disabled. Explicit rules only by subsequent stages
  create_database_subnet_group  = false
  manage_default_network_acl    = false
  manage_default_security_group = false

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  vpc_flow_log_iam_role_name            = "vpc-${var.profile}-flow-logs"
  vpc_flow_log_iam_role_use_name_prefix = false
  enable_flow_log                       = var.enable_flow_log
  create_flow_log_cloudwatch_log_group  = var.enable_flow_log
  create_flow_log_cloudwatch_iam_role   = var.enable_flow_log
  flow_log_max_aggregation_interval     = 60

  tags = {
    Environment = var.profile
  }
}
