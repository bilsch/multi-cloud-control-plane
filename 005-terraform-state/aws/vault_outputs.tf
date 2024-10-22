resource "vault_generic_secret" "s3_bucket" {
  path = "bilsch/aws/${var.name}/s3_bucket"

  data_json = jsonencode(
    {
      "bucket" = module.s3_bucket.bucket
    }
  )
}
