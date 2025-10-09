module "boilerplate_project" {
  source = "./modules/managed-project"

  allowed_repos     = ["aws-boilerplate"]
  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  github_pat        = var.github_pat
  account_id        = local.account_id

  allowed_branches         = ["main"]
  permissions_boundary_arn = aws_iam_policy.pb_control_plane.arn
  prefix                   = local.prefix
  project_prefix           = "boilerplate"

  inline_policies = {
    "deploy" = data.aws_iam_policy_document.deploy_manage_iam.json
  }

  policy_modules = ["state"]
}