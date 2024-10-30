resource "vault_kv_secret_v2" "this" {
  mount               = "secret"
  name                = "bilsch/azure/${var.profile}/vpc"
  delete_all_versions = true

  data_json = jsonencode({
    # https://github.com/bilsch/terraform-azure-vpc/blob/main/output.tf
    "nat_gateway_public_ip" = module.vpc.nat_gateway_public_ip,
  })
}
