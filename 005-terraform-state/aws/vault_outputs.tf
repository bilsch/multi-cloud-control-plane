resource "vault_kv_secret_v2" "terraform_state_store" {
  mount               = "secret"
  name                = "multi-cloud/aws/${var.profile}/terraform_state_store"
  cas                 = 1
  delete_all_versions = true

  data_json = jsonencode({
    "s3_bucket_arn"                = module.s3_bucket.s3_bucket_arn,
    "s3_bucket_bucket_domain_name" = module.s3_bucket.s3_bucket_bucket_domain_name,
    "s3_bucket_id"                 = module.s3_bucket.s3_bucket_id
  })

  custom_metadata {
    max_versions = 5
    data = {
      profile = var.profile,
    }
  }
}
