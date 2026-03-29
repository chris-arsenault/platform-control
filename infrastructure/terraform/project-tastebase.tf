module "project_tastebase" {
  source = "./modules/managed-project"

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  account_id        = local.account_id

  github_pat         = var.github_pat
  allowed_repos      = ["tastebase"]
  allowed_branches   = ["main"]
  allow_pull_request = true

  prefix           = "tastebase"
  state_key_prefix = "projects/tastebase"
  policy_modules = [
    "terraform-state",
    "lambda-deploy",
    "alb-target-group",
    "cognito-client",
    "s3-website",
    "cloudfront-distribution",
    "acm-dns",
    "bedrock-inference",
    "iam-roles",
    "db-migrate",
  ]
}
