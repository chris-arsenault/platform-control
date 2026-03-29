module "project_svap" {
  source = "./modules/managed-project"

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  account_id        = local.account_id

  github_pat         = var.github_pat
  allowed_repos      = ["svap"]
  allowed_branches   = ["main"]
  allow_pull_request = true

  prefix           = "svap"
  state_key_prefix = "projects/svap"
  policy_modules = [
    "terraform-state",
    "lambda-deploy",
    "cognito-client",
    "s3-website",
    "cloudfront-distribution",
    "acm-dns",
    "bedrock-inference",
    "iam-roles",
    "db-migrate",
  ]
}
