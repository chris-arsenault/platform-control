# =============================================================================
# Shared Terraform state bucket — all projects store state here
# =============================================================================

resource "aws_s3_bucket" "shared_state" {
  bucket = "tfstate-${local.account_id}"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "shared_state" {
  bucket = aws_s3_bucket.shared_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "shared_state" {
  bucket = aws_s3_bucket.shared_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "shared_state" {
  bucket = aws_s3_bucket.shared_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "shared_state" {
  bucket = aws_s3_bucket.shared_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyBareStateKeys"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.shared_state.id}/terraform.tfstate"
      },
      {
        Sid       = "DenyBareStateLock"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.shared_state.id}/.terraform.lock.hcl"
      }
    ]
  })
}
