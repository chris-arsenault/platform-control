locals {
  migrations_bucket = "platform-migrations-${var.account_id}"
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "MigrationsBucketList"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = ["arn:aws:s3:::${local.migrations_bucket}"]
  }

  statement {
    sid    = "MigrationsBucketReadWrite"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["arn:aws:s3:::${local.migrations_bucket}/migrations/${var.prefix}/*"]
  }

  statement {
    sid       = "InvokeMigrateLambda"
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = ["arn:aws:lambda:*:${var.account_id}:function:platform-db-migrate"]
  }
}
