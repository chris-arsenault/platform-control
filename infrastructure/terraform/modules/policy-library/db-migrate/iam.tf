locals {
  migrations_bucket = "platform-migrations-${var.account_id}"

  # Object key prefixes this policy grants write access to.
  # - migrations/{prefix}/*: per-project DB migration SQL files
  # - platform/*: platform-only artifacts (og-server binary, etc.),
  #   only granted when the project prefix is "platform"
  migrations_bucket_prefixes = var.prefix == "platform" ? [
    "arn:aws:s3:::${local.migrations_bucket}/migrations/${var.prefix}/*",
    "arn:aws:s3:::${local.migrations_bucket}/platform/*",
    ] : [
    "arn:aws:s3:::${local.migrations_bucket}/migrations/${var.prefix}/*",
  ]
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "MigrationsBucketManagement"
    effect = "Allow"
    actions = [
      "s3:CreateBucket",
      "s3:ListBucket",
      "s3:ListBucketVersions",
      "s3:GetBucketLocation",
      "s3:PutBucketTagging",
      "s3:PutBucketVersioning",
      "s3:PutBucketPublicAccessBlock",
      "s3:PutEncryptionConfiguration",
      "s3:Get*"
    ]
    resources = ["arn:aws:s3:::${local.migrations_bucket}"]
  }

  # The migrations bucket has versioning enabled, so delete operations
  # on individual object versions require s3:DeleteObjectVersion.
  statement {
    sid    = "MigrationsBucketReadWrite"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
    ]
    resources = local.migrations_bucket_prefixes
  }

  statement {
    sid       = "InvokeMigrateLambda"
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = ["arn:aws:lambda:*:${var.account_id}:function:platform-db-migrate"]
  }
}
