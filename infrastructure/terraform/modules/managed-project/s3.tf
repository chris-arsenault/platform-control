# --- S3 bucket for remote state ---
resource "aws_s3_bucket" "tf_state" {
  count = contains(var.policy_modules, "state") ? 1 : 0

  bucket = module.state.state_bucket

  lifecycle {
    prevent_destroy = true
  }
}

# Enable versioning to keep history of state files
resource "aws_s3_bucket_versioning" "tf_state" {
  count = contains(var.policy_modules, "state") ? 1 : 0

  bucket = aws_s3_bucket.tf_state[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

# Default encryption for state files
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  count = contains(var.policy_modules, "state") ? 1 : 0

  bucket = aws_s3_bucket.tf_state[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

