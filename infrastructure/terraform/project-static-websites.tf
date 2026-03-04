module "project_websites" {
  source = "./modules/managed-project"

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  account_id        = local.account_id

  github_pat         = var.github_pat
  allowed_repos      = ["websites", "svap", "the-canonry", "hot-mic", "slipstream"]
  allowed_branches   = ["main"]
  allow_pull_request = true

  prefix = "websites"
  policy_modules = [
    "state",
    "api",
    "bedrock",
    "iam",
    "static-website"
  ]
}
