data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id


  deployment_repo = "chris-arsenault/aws-boilerplate"

  deployment_role_name = "boilerplate-deployer"

  control_plane_permissions_boundary_name      = "${local.prefix}-deploy-control-plane"
  project_guardrails_permissions_boundary_name = "${local.prefix}-project-guardrails"

  deploy_boundary_arn  = "arn:aws:iam::${local.account_id}:policy/${local.control_plane_permissions_boundary_name}"
  project_boundary_arn = "arn:aws:iam::${local.account_id}:policy/${local.project_guardrails_permissions_boundary_name}"

  # Common ARNs
  all_roles_arn_prefix = "arn:aws:iam::${local.account_id}:role"
  prefixed_roles_arn   = "arn:aws:iam::${local.account_id}:role/${local.prefix}-*"
  all_policies_arn     = "arn:aws:iam::${local.account_id}:policy/*"
  all_users_arn        = "arn:aws:iam::${local.account_id}:user/*"
  all_groups_arn       = "arn:aws:iam::${local.account_id}:group/*"

  allowed_managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]
}