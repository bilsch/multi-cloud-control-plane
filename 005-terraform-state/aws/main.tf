resource "random_string" "this" {
  length  = 12
  lower   = true
  upper   = false
  special = false
}

resource "aws_s3_bucket" "this" {
  bucket = "terraform-state-${var.name}-${resource.random_string.this.result}"
  tags = {
    project = var.name,
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 5
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket            = aws_s3_bucket.this.id
  block_public_acls = true
}
