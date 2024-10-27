locals {
  # TODO this path sucks!
  config = yamldecode(file("/Users/bilsch/gits/multi-cloud-control-configs-private/clouds/aws/${var.profile}.yaml"))

  network_acls = {
    # TODO: Do we want to allow anything by default?
    default_inbound = [
    ]

    default_outbound = [
    ]

    public_inbound = [for rule in local.config.vpc.acls.public.inbound : rule]

    public_outbound = []

    private_inbound = []

    private_outbound = []

    database_inbound = []

    database_outbound = []

    # aka kubernetes
    infra_inbound = [
    ]

    infra_outbound = [
    ]
  }
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

  # apply our default inbound/outbound
  # note unless you override these default to drop
  # Anything you add to a given subnet you must also put in explicit rules to allow traffic!

  public_dedicated_network_acl = true
  public_inbound_acl_rules     = concat(local.network_acls["default_inbound"], local.network_acls["public_inbound"])
  public_outbound_acl_rules    = concat(local.network_acls["default_outbound"], local.network_acls["public_outbound"])

  private_dedicated_network_acl = true
  private_inbound_acl_rules     = concat(local.network_acls["default_inbound"], local.network_acls["private_inbound"])
  private_outbound_acl_rules    = concat(local.network_acls["default_outbound"], local.network_acls["private_outbound"])

  database_dedicated_network_acl = true
  database_inbound_acl_rules     = concat(local.network_acls["default_inbound"], local.network_acls["database_inbound"])
  database_outbound_acl_rules    = concat(local.network_acls["default_outbound"], local.network_acls["database_outbound"])

  intra_dedicated_network_acl = true
  intra_inbound_acl_rules     = concat(local.network_acls["default_inbound"], local.network_acls["infra_inbound"])
  intra_outbound_acl_rules    = concat(local.network_acls["default_outbound"], local.network_acls["infra_outbound"])

  public_subnet_names   = ["public-0", "public-1", "public-2"]
  database_subnet_names = ["database-0", "database-1", "database-2"]
  intra_subnet_names    = ["kubernetes-0", "kubernetes-1", "kubernetes-2"]

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  # ipv6 support
  enable_ipv6                                   = local.config.vpc.ipv6_enabled
  public_subnet_assign_ipv6_address_on_creation = local.config.vpc.ipv6_enabled
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
  enable_flow_log                       = local.config.vpc.enable_flow_log
  create_flow_log_cloudwatch_log_group  = local.config.vpc.enable_flow_log
  create_flow_log_cloudwatch_iam_role   = local.config.vpc.enable_flow_log
  flow_log_max_aggregation_interval     = 60

  tags = {
    Environment = var.profile
  }
}
