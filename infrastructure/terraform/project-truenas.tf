module "project_truenas" {
  source = "./modules/managed-project"

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  account_id        = local.account_id

  github_pat         = var.github_pat
  allowed_repos      = ["truenas"]
  allowed_branches   = ["main"]
  allow_pull_request = true

  prefix           = "truenas"
  state_key_prefix = "projects/truenas"
  policy_modules = [
    "terraform-state",
    "komodo-deploy",
    "cognito-client",
    "ssm-write",
    "lambda-deploy",
    "iam-roles"
  ]

  ssm_additional_parameter_paths = [
    "platform/sonarqube/*",
    "platform/auth-trigger/clients/*"
  ]
}
