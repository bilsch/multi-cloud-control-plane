#
# Note this is based on https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/karpenter/
#

locals {
  # TODO this path sucks!
  config = yamldecode(file("/Users/bilsch/gits/multi-cloud-control-configs-private/clouds/aws/${var.profile}.yaml"))
}

provider "aws" {
  region = local.config.provider.region
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

data "vault_kv_secret_v2" "vpc_id" {
  mount = "secret"
  name  = "bilsch/aws/${var.profile}/vpc"
}

data "aws_caller_identity" "this" {}

data "aws_availability_zones" "this" {}

data "aws_vpc" "this" {
  id = data.vault_kv_secret_v2.vpc_id.data_json.vpc_id
}

data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

data "aws_subnet" "private" {
  filter {
    name   = "tag:Name"
    values = ["private*"]
  }
}

data "aws_subnet" "kubernetes" {
  filter {
    name   = "tag:Name"
    values = ["kubernetes*"]
  }
}

#
# The actual eks setup
#
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

provider "kubectl" {
  apply_retry_count      = 5
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.profile
  cluster_version = local.config.kubernetes.versions.kubernetes

  cluster_endpoint_public_access = true

  cluster_addons = {
    # TODO: do we need to specify specific versions here or just take the defaults?
    #       The module docs do not indicate how to specify versions
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = data.aws_vpc.this.vpc_id
  subnet_ids               = data.aws_subnet.kubernetes.*.id
  control_plane_subnet_ids = data.aws_subnet.private.*.id

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = local.config.kubernetes.instance_types
  }

  eks_managed_node_groups = {
    default = {
      ami_type       = local.config.kubernetes.ami_type
      instance_types = local.config.kubernetes.instance_types

      min_size     = local.config.kubernetes.default_node_group.min_size
      max_size     = local.config.kubernetes.default_node_group.max_size
      desired_size = local.config.kubernetes.default_node_group.desired_size
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  tags = {
    name = var.profile
  }
}

module "karpenter" {
  source = "../../modules/karpenter"

  cluster_name = module.eks.cluster_name

  enable_v1_permissions = true

  enable_pod_identity             = true
  create_pod_identity_association = true

  # Used to attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = local.tags
}
