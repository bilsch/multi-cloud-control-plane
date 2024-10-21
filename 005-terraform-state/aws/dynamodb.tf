resource "aws_dynamodb_table" "this" {
  name             = "lab_terraform_state"
  billing_mode     = "PAY_PER_REQUEST"
  read_capacity    = 5
  write_capacity   = 5
  hash_key         = "LockID"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.this.key_id
  }
}
