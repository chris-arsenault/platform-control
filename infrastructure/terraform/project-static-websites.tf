module "project_websites" {
  source         = "./modules/managed-project"
  prefix         = local.prefix
  project_prefix = "websites"

  oidc_provider_arn  = aws_iam_openid_connect_provider.github.arn
  github_pat         = var.github_pat
  account_id         = local.account_id
  allowed_repos      = ["websites"]
  allowed_branches   = ["main"]
  allow_pull_request = true

  permissions_boundary_arn = aws_iam_policy.pb_project_guardrails.arn

  policy_modules = [
    "state",
    "api",
    "bedrock",
    "iam",
    "static-website"
  ]
}
