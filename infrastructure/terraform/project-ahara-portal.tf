module "project_ahara_portal" {
  source = "./modules/managed-project"

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  account_id        = local.account_id

  github_pat         = local.github_pat
  allowed_repos      = ["ahara-portal"]
  allowed_branches   = ["main"]
  allow_pull_request = true

  prefix           = "ahara-portal"
  state_key_prefix = "projects/ahara-portal"
  policy_modules = [
    "terraform-state",
    "cognito-client",
    "ssm-write",
    "iam-roles",
    "lambda-deploy",
    "acm-dns",
    "alb-target-group",
    "dynamodb",
    "cloudfront-distribution",
    "s3-website",
  ]

  ssm_additional_parameter_paths = [
    "platform/cognito/*",
  ]
}
