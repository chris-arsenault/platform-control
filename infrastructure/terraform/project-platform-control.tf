module "boilerplate_project" {
  source = "./modules/managed-project"

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  account_id        = local.account_id

  github_pat         = local.github_pat
  allowed_repos      = ["platform-control"]
  allowed_branches   = ["main"]
  allow_pull_request = true

  prefix           = "boilerplate"
  state_key_prefix = "platform"
  policy_modules   = ["control-plane", "terraform-state"]
}
