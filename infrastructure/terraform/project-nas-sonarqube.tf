module "project_nas_sonarqube" {
  source = "./modules/managed-project"

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  account_id        = local.account_id

  github_pat         = local.github_pat
  allowed_repos      = ["nas-sonarqube"]
  allowed_branches   = ["main"]
  allow_pull_request = true

  prefix           = "nas-sonarqube"
  state_key_prefix = "projects/nas-sonarqube"
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
