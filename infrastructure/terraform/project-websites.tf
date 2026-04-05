module "project_websites" {
  source = "./modules/managed-project"

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  account_id        = local.account_id

  github_pat         = local.github_pat
  allowed_repos      = ["websites"]
  allowed_branches   = ["main"]
  allow_pull_request = true

  prefix           = "websites"
  state_key_prefix = "projects/websites"
  policy_modules = [
    "terraform-state",
    "lambda-deploy",
    "dynamodb",
    "s3-website",
    "cloudfront-distribution",
    "acm-dns",
    "bedrock-inference",
    "iam-roles",
  ]
}
