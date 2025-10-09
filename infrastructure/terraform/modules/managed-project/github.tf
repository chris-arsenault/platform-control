

resource "github_actions_secret" "state_bucket" {
  for_each = var.allowed_repos

  repository      = each.value
  secret_name     = "STATE_BUCKET"
  plaintext_value = aws_s3_bucket.tf_state[0].bucket
}

resource "github_actions_secret" "state_table" {
  for_each = var.allowed_repos

  repository      = each.value
  secret_name     = "STATE_TABLE"
  plaintext_value = aws_dynamodb_table.tf_lock[0].name
}

resource "github_actions_secret" "oidc_role" {
  for_each = var.allowed_repos

  repository      = each.value
  secret_name     = "OIDC_ROLE"
  plaintext_value = aws_iam_role.this.arn
}


resource "github_actions_secret" "prefix" {
  for_each = var.allowed_repos

  repository      = each.value
  secret_name     = "PREFIX"
  plaintext_value = var.prefix
}


resource "github_actions_secret" "project_prefix" {
  for_each = var.allowed_repos

  repository      = each.value
  secret_name     = "PROJECT_PREFIX"
  plaintext_value = var.project_prefix
}
