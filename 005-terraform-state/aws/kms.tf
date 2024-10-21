resource "aws_kms_key" "this" {
  enable_key_rotation     = true
  deletion_window_in_days = 30
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      },
    # TODO: We probably need more work here. Wild cards do not work here
    #   {
    #     Sid    = "Allow administration of the key"
    #     Effect = "Allow"
    #     Principal = {
    #       AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:*"
    #     },
    #     Action = [
    #       "kms:ReplicateKey",
    #       "kms:Create*",
    #       "kms:Describe*",
    #       "kms:Enable*",
    #       "kms:List*",
    #       "kms:Put*",
    #       "kms:Update*",
    #       "kms:Revoke*",
    #       "kms:Disable*",
    #       "kms:Get*",
    #       "kms:Delete*",
    #       "kms:ScheduleKeyDeletion",
    #       "kms:CancelKeyDeletion"
    #     ],
    #     Resource = "*"
    #   },
    #   {
    #     Sid    = "Allow use of the key"
    #     Effect = "Allow"
    #     Principal = {
    #       AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:*"
    #     },
    #     Action = [
    #       "kms:DescribeKey",
    #       "kms:Encrypt",
    #       "kms:Decrypt",
    #       "kms:ReEncrypt*",
    #       "kms:GenerateDataKey",
    #       "kms:GenerateDataKeyWithoutPlaintext"
    #     ],
    #     Resource = "*"
    #   }
    ]
  })
  tags = {
    name = "lab-default"
  }
}