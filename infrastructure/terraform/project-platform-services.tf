module "platform_services_project" {
  source = "./modules/managed-project"

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  account_id        = local.account_id

  github_pat         = var.github_pat
  allowed_repos      = ["platform-services"]
  allowed_branches   = ["main"]
  allow_pull_request = true

  prefix           = "platform"
  state_key_prefix = "platform"
  policy_modules = [
    "terraform-state",
    "lambda-deploy",
    "alb-target-group",
    "cognito-pool",
    "cognito-client",
    "dynamodb",
    "rds",
    "sns",
    "acm-dns",
    "budgets-costexplorer",
    "ssm-write",
    "ec2-security-groups",
    "iam-roles",
    "iam-instance-profiles",
  ]
}
