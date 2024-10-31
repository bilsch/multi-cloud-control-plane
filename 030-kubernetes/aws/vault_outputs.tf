# resource "vault_kv_secret_v2" "this" {
#   mount               = "secret"
#   name                = "bilsch/aws/${var.profile}/kubernetes"
#   delete_all_versions = true

#   data_json = jsonencode({
#     # https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/outputs.tf
#     "nat_public_ips"                = module.vpc.nat_public_ips,
#   })
# }
