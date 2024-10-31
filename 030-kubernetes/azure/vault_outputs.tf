# resource "vault_kv_secret_v2" "this" {
#   mount               = "secret"
#   name                = "bilsch/azure/${var.profile}/kubernetes"
#   delete_all_versions = true

#   data_json = jsonencode({
#     "nat_gateway_public_ip" = module.vpc.nat_gateway_public_ip,
#   })
# }
