resource "vault_mount" "kvv1" {
  path        = "bilsch/aws/${var.profile}"
  type        = "kv"
  options     = { version = "1" }
  description = "KV Version 1 secret engine mount"
}

resource "vault_kv_secret" "secret" {
  path = "${vault_mount.kvv1.path}/s3_bucket"
  data_json = jsonencode({
    "s3_bucket_arn"                = module.s3_bucket.s3_bucket_arn,
    "s3_bucket_bucket_domain_name" = module.s3_bucket.s3_bucket_bucket_domain_name,
    "s3_bucket_id"                 = module.s3_bucket.s3_bucket_id
  })
}
