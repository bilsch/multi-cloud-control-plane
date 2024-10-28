resource "vault_kv_secret_v2" "this" {
  mount               = "secret"
  name                = "bilsch/azure/${var.profile}/vpc"
  delete_all_versions = true

  data_json = jsonencode({
    # https://github.com/bilsch/terraform-azure-vpc/blob/main/output.tf
    "vpc_id"                       = module.vpc.vpc_id,
    "vpc_name"                     = module.vpc.vpc_name,
    "vpc_subnet"                   = module.vpc.vpc_subnet,
    "public_ids"                   = module.vpc.public_ids,
    "public_names"                 = module.vpc.public_names,
    "public_service_endpoints"     = module.vpc.public_service_endpoints,
    "private_ids"                  = module.vpc.private_ids,
    "private_names"                = module.vpc.private_names,
    "private_service_endpoints"    = module.vpc.private_service_endpoints,
    "database_ids"                 = module.vpc.database_ids,
    "database_names"               = module.vpc.database_names,
    "database_service_endpoints"   = module.vpc.database_service_endpoints,
    "kubernetes_ids"               = module.vpc.kubernetes_ids,
    "kubernetes_names"             = module.vpc.kubernetes_names,
    "kubernetes_service_endpoints" = module.vpc.kubernetes_service_endpoints,
  })
}
