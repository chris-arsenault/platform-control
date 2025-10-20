module "vpn_project" {
  source = "./modules/managed-project"

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  account_id        = local.account_id

  github_pat         = var.github_pat
  allowed_repos      = ["vpn"]
  allowed_branches   = ["main"]
  allow_pull_request = true

  prefix         = "vpn"
  policy_modules = ["vpn", "state"]
}
