resource "github_actions_secret" "state_bucket" {
  for_each = var.allowed_repos

  repository      = each.value
  secret_name     = "STATE_BUCKET"
  plaintext_value = aws_s3_bucket.tf_state[0].bucket
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


resource "github_actions_secret" "pb_arn" {
  for_each = var.allowed_repos

  repository      = each.value
  secret_name     = "PB_ARN"
  plaintext_value = aws_iam_policy.pb_project_guardrails.arn
}
