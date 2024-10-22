resource "random_string" "this" {
  length  = 12
  lower   = true
  upper   = false
  special = false
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.2.1"

  allowed_kms_key_arn = aws_kms_key.this.arn

  # these are both defaults but just to be safe
  block_public_acls   = true
  block_public_policy = true

  bucket              = "terraform-state-${var.name}-${resource.random_string.this.result}"
  object_lock_enabled = true
  object_ownership    = "ObjectWriter"

  object_lock_configuration = {
    rule = {
      default_retention = {
        mode = "GOVERNANCE"
        days = 1
      }
    }
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.this.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning = {
    enabled = true
  }

  tags = {
    profile = var.name,
  }
}
