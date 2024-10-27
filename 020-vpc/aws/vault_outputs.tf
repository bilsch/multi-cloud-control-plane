resource "vault_kv_secret_v2" "this" {
  mount               = "secret"
  name                = "bilsch/aws/${var.profile}/vpc"
  cas                 = 1
  delete_all_versions = true

  data_json = jsonencode({
    # https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/outputs.tf
    "nat_public_ips"      = module.vpc.nat_public_ips,
    "vpc_ipv6_cidr_block" = module.vpc.vpc_ipv6_cidr_block,
  })

  custom_metadata {
    max_versions = 5
    data = {
      profile = var.profile,
    }
  }
}
