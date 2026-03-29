module "vpn_project" {
  source = "./modules/managed-project"

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  account_id        = local.account_id

  github_pat         = var.github_pat
  allowed_repos      = ["platform-network"]
  allowed_branches   = ["main"]
  allow_pull_request = true

  prefix                         = "vpn"
  state_key_prefix               = "platform"
  ssm_additional_parameter_paths = ["platform/network/*"]
  policy_modules = [
    "terraform-state",
    "ec2-vpc-compute",
    "alb-loadbalancer",
    "alb-target-group",
    "wafv2",
    "cloudfront-distribution",
    "acm-dns",
    "cognito-pool",
    "cognito-client",
    "cognito-identity-pool",
    "iam-roles",
    "iam-instance-profiles",
    "ssm-write",
    "secrets-manager",
  ]
}
